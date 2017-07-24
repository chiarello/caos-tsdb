#!/usr/bin/env bash

################################################################################
#
# caos-tsdb - CAOS Time-Series DB
#
# Copyright © 2017 INFN - Istituto Nazionale di Fisica Nucleare (Italy)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Author: Fabrizio Chiarello <fabrizio.chiarello@pd.infn.it>
#
################################################################################

DOCKER_BUILD_IMAGE="elixir:1.4"

SCRIPT=$(basename "$0")
USAGE="$SCRIPT [<options>]
  Options:
    -h, --help                          Show help information
    -t, --target <commit> | <tag>       The commit or the tag to be built. Defaults to HEAD."

function die() {
    format=${1:-""}
    shift
    printf >&2 "$format\n" "$@"
    exit 1
}

function say() {
    format=${1:-""}
    shift
    printf "${format}\n" "$@"
}

function show_usage() {
    echo "usage: ${USAGE}"
}

OPTS=$(getopt -o ht: -l help,target: -n ${SCRIPT} -- "$@")
if [ $? != 0 ] ; then
    show_usage
    die
fi
eval set -- "${OPTS}"

target=HEAD
while true ; do
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -t|--target)
            target="$2"
            shift 2
            ;;
        --)
            shift
            ;;
        "")
            break
            ;;
        *)
            show_usage
            die "Unknown argument: %s" $1
            ;;
    esac
done

# check if we are in a git working tree
is_inside_git_working_tree=$(git rev-parse --is-inside-work-tree 2>/dev/null)
if [ ${is_inside_git_working_tree} != true ] ; then
    die "This script must be used inside a git working tree."
fi

# go to the top level
top_level_dir=$(git rev-parse --show-toplevel)
cd ${top_level_dir} || die "Cannot go to top level dir: %s" ${top_level_dir}

ret=$(git describe --long $target 2>&1)
if [ $? != 0 ] ; then
    die "Unable to find '%s' (git: '%s')" "${target}" "${ret}"
fi
git_version=$ret

function git_to_semver () {
    local git_version=$1
    local version=$(echo ${git_version} | awk '{ split($0, r, "-"); print r[1] }' | sed -e 's/^v//' )
    local count=$(echo ${git_version} | awk '{ split($0, r, "-"); print r[2] }' )
    local sha=$(echo ${git_version} | awk '{ split($0, r, "-"); print r[3] }' )

    if [ ${count} == 0 ] ; then
        echo "${version}"
    else
        echo "${version}.${count}+${sha}"
    fi
}

semver=$(git_to_semver ${git_version})

say "
Target:      ${target}
Git version: ${git_version}
Semver:      ${semver}
"

releases_dir=releases
if [ ! -d ${releases_dir} ] ; then
    say "Creating %s" ${releases_dir}
    mkdir -p ${releases_dir}
fi

archive_fname="caos-tsdb-src-${semver}.tar.gz"
release_fname="caos-tsdb-${semver}.tar.gz"
archive_prefix="caos-tsdb/"
git archive --prefix=${archive_prefix} -o ${releases_dir}/${archive_fname} ${git_version}
say "Created archive: %s\n" ${archive_fname}

container_id=$(docker run -t -d -v /${archive_prefix} -w /${archive_prefix} -v $(readlink -e ${releases_dir}/${archive_fname}):/${archive_fname}:ro --entrypoint /bin/bash ${DOCKER_BUILD_IMAGE})
say "Started container: %s\n" ${container_id}

function docker_exec () {
    docker exec "$@"
    if [ $? != 0 ] ; then
        die "Docker error"
    fi
}

docker_exec ${container_id} tar xfz /${archive_fname} --strip-components=1
say "Deployed sources\n"

say "Installing deps"
docker_exec ${container_id} mix local.hex --force
docker_exec ${container_id} mix local.rebar --force
docker_exec ${container_id} mix deps.get --only prod

say "Building release"
docker_exec -e "CAOS_TSDB_RELEASE_VERSION=${semver}" -e "MIX_ENV=prod" ${container_id} mix compile
docker_exec -e "CAOS_TSDB_RELEASE_VERSION=${semver}" -e "MIX_ENV=prod" ${container_id} mix release --verbose
say "Compilation done\n"

docker cp "${container_id}:/${archive_prefix}/_build/prod/rel/caos_tsdb/releases/${semver}/caos_tsdb.tar.gz" ${releases_dir}/${release_fname}
say "Grabbed release to %s\n" ${releases_dir}/${release_fname}

docker stop ${container_id}
say "Stopped container: %s\n" ${container_id}

docker rm ${container_id}
say "Removed container: %s\n" ${container_id}

say "Building docker release"
docker build -t caos-tsdb:${git_version} --build-arg RELEASE_FILE=${release_fname} --build-arg RELEASES_DIR=${releases_dir} .
say "Docker release built\n"
