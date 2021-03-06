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

FROM elixir:1.5

LABEL maintainer "Fabrizio Chiarello <fabrizio.chiarello@pd.infn.it>"

ARG RELEASE_FILE
ADD $RELEASE_FILE /caos-tsdb

WORKDIR /caos-tsdb

ENV LANG=C.UTF-8

ENV CONFORM_CONF_PATH=/etc/caos/caos-tsdb.conf

# Add an empty configuration file
RUN mkdir /etc/caos
COPY config/caos_tsdb.conf ${CONFORM_CONF_PATH}
VOLUME /etc/caos

RUN mkdir /var/log/caos
VOLUME /var/log/caos

ENTRYPOINT [ "bin/caos_tsdb" ]
CMD [ "--help" ]
