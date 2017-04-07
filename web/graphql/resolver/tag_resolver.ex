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

defmodule CaosTsdb.Graphql.Resolver.TagResolver do
  use CaosTsdb.Web, :resolver

  alias CaosTsdb.Tag

  def get_one(args, _) when args == %{} do
    graphql_error(:no_arguments_given)
  end

  def get_one(args, _) do
    try do
      case Repo.get_by(Tag, args) do
        nil -> graphql_error(:not_found, "Tag")
        tag -> {:ok, tag}
      end
    rescue
      Ecto.MultipleResultsError -> graphql_error(:multiple_results)
    end
  end

  def get_all(args, _) when args == %{} do
    {:ok, Tag |> Repo.all}
  end

  def get_all(args, _) do
    tags = Tag
    |> CaosTsdb.QueryFilter.filter(%Tag{}, args, [:id, :key, :value])
    |> Repo.all

    {:ok, tags}
  end

  def series_by_tag(_, tag_ids) do
    Tag
    |> where([t], t.id in ^tag_ids)
    |> join(:inner, [t], s in assoc(t, :series))
    |> preload([_, s], [series: s])
    |> Repo.all
    |> Map.new(&{&1.id, &1.series})
  end

  def create(args, _) when args == %{} do
    graphql_error(:no_arguments_given)
  end

  def create(args, _) do
    %Tag{}
    |> Tag.changeset(args)
    |> Repo.insert
    |> changeset_to_graphql
  end

  def get_or_create(args, context) do
    case Repo.get_by(Tag, args) do
      nil -> create(args, context)
      tag -> {:ok, tag}
    end
  end
end