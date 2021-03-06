################################################################################
#
# caos-tsdb - CAOS Time-Series DB
#
# Copyright © 2016, 2017 INFN - Istituto Nazionale di Fisica Nucleare (Italy)
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

@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [],
  mappings: [
    "logger.console.level": [
      env_var: "CAOS_TSDB_LOGGER_CONSOLE_LEVEL",
      commented: true,
      datatype: :atom,
      default: :info,
      doc: "Console logger level.",
      hidden: false,
      to: "logger.console.level"
    ],
    "logger.console.utc": [
      env_var: "CAOS_TSDB_LOGGER_CONSOLE_UTC",
      commented: true,
      datatype: :atom,
      default: true,
      doc: "Console logger utc.",
      hidden: false,
      to: "logger.console.utc_log"
    ],
    "logger.console.format": [
      env_var: "CAOS_TSDB_LOGGER_CONSOLE_FORMAT",
      commented: true,
      datatype: :binary,
      default: "\n$date $time [$level]$levelpad $metadata $message\n",
      doc: "Console logger format.",
      hidden: false,
      to: "logger.console.format"
    ],
    "logger.error_file.path": [
      env_var: "CAOS_TSDB_LOGGER_ERROR_FILE_PATH",
      commented: true,
      datatype: :binary,
      default: "/var/log/caos/tsdb.error.log",
      doc: "Error file logger path.",
      hidden: false,
      to: "logger.error_file.path"
    ],
    "logger.error_file.level": [
      env_var: "CAOS_TSDB_LOGGER_ERROR_FILE_LEVEL",
      commented: true,
      datatype: :atom,
      default: :error,
      doc: "Error file logger level.",
      hidden: false,
      to: "logger.error_file.level"
    ],
    "logger.error_file.utc": [
      env_var: "CAOS_TSDB_LOGGER_ERROR_FILE_UTC",
      commented: true,
      datatype: :atom,
      default: true,
      doc: "Error file logger utc.",
      hidden: false,
      to: "logger.error_file.utc_log"
    ],
    "logger.error_file.format": [
      env_var: "CAOS_TSDB_LOGGER_ERROR_FILE_FORMAT",
      commented: true,
      datatype: :binary,
      default: "\n$date $time [$level]$levelpad $metadata $message\n",
      doc: "Error file logger path.",
      hidden: false,
      to: "logger.error_file.format"
    ],
    "logger.log_file.path": [
      env_var: "CAOS_TSDB_LOGGER_LOG_FILE_PATH",
      commented: true,
      datatype: :binary,
      default: "/var/log/caos/tsdb.log",
      doc: "Log file logger path.",
      hidden: false,
      to: "logger.log_file.path"
    ],
    "logger.log_file.level": [
      env_var: "CAOS_TSDB_LOGGER_LOG_FILE_LEVEL",
      commented: true,
      datatype: :atom,
      default: :info,
      doc: "Log file logger level.",
      hidden: false,
      to: "logger.log_file.level"
    ],
    "logger.log_file.utc": [
      env_var: "CAOS_TSDB_LOGGER_LOG_FILE_UTC",
      commented: true,
      datatype: :atom,
      default: true,
      doc: "Log file logger utc.",
      hidden: false,
      to: "logger.log_file.utc_log"
    ],
    "logger.log_file.format": [
      env_var: "CAOS_TSDB_LOGGER_LOG_FILE_FORMAT",
      commented: true,
      datatype: :binary,
      default: "\n$date $time [$level]$levelpad $metadata $message\n",
      doc: "Log file logger format.",
      hidden: false,
      to: "logger.log_file.format"
    ],
    "caos_tsdb.ecto_repos": [
      commented: false,
      datatype: [
        list: :atom
      ],
      default: [
        CaosTsdb.Repo
      ],
      doc: "Provide documentation for caos_tsdb.ecto_repos here.",
      hidden: true,
      to: "caos_tsdb.ecto_repos"
    ],
    "hostname": [
      env_var: "CAOS_TSDB_HOSTNAME",
      commented: true,
      datatype: :binary,
      default: "localhost",
      doc: "Server hostname.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.url.host"
    ],
    "port": [
      env_var: "CAOS_TSDB_PORT",
      commented: true,
      datatype: :integer,
      default: 80,
      doc: "Server port.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.http.port"
    ],
    "caos_tsdb.Elixir.CaosTsdb.Endpoint.render_errors.view": [
      commented: false,
      datatype: :atom,
      default: CaosTsdb.ErrorView,
      doc: "Provide documentation for caos_tsdb.Elixir.CaosTsdb.Endpoint.render_errors.view here.",
      hidden: true,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.render_errors.view"
    ],
    "caos_tsdb.Elixir.CaosTsdb.Endpoint.render_errors.accepts": [
      commented: false,
      datatype: [
        list: :binary
      ],
      default: [
        "json"
      ],
      doc: "Provide documentation for caos_tsdb.Elixir.CaosTsdb.Endpoint.render_errors.accepts here.",
      hidden: true,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.render_errors.accepts"
    ],
    "caos_tsdb.Elixir.CaosTsdb.Endpoint.url.port": [
      commented: false,
      datatype: :integer,
      default: 80,
      doc: "Provide documentation for caos_tsdb.Elixir.CaosTsdb.Endpoint.http.port here.",
      hidden: true,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.url.port"
    ],
    "caos_tsdb.Elixir.CaosTsdb.Endpoint.server": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for caos_tsdb.Elixir.CaosTsdb.Endpoint.server here.",
      hidden: true,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.server"
    ],
    "caos_tsdb.Elixir.CaosTsdb.Endpoint.root": [
      commented: false,
      datatype: :binary,
      default: ".",
      doc: "Provide documentation for caos_tsdb.Elixir.CaosTsdb.Endpoint.root here.",
      hidden: true,
      to: "caos_tsdb.Elixir.CaosTsdb.Endpoint.root"
    ],
    "foreseen_sample_threshold": [
      env_var: "CAOS_TSDB_FORESEEN_SAMPLE_THRESHOLD",
      commented: true,
      datatype: :integer,
      default: 20,
      doc: "Foreseen sample threshold.",
      hidden: false,
      to: "caos_tsdb.Elixir.ForeseenSample.threshold"
    ],
    "caos_tsdb.Elixir.CaosTsdb.Repo.adapter": [
      commented: false,
      datatype: :atom,
      default: Ecto.Adapters.MySQL,
      doc: "Provide documentation for caos_tsdb.Elixir.CaosTsdb.Repo.adapter here.",
      hidden: true,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.adapter"
    ],
    "db.username": [
      env_var: "CAOS_TSDB_DB_USERNAME",
      commented: true,
      datatype: :binary,
      default: "caos",
      doc: "DB username.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.username"
    ],
    "db.password": [
      env_var: "CAOS_TSDB_DB_PASSWORD",
      commented: true,
      datatype: :binary,
      default: "",
      doc: "DB password.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.password"
    ],
    "db.name": [
      env_var: "CAOS_TSDB_DB_NAME",
      commented: true,
      datatype: :binary,
      default: "caos",
      doc: "DB name.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.database"
    ],
    "db.hostname": [
      env_var: "CAOS_TSDB_DB_HOSTNAME",
      commented: true,
      datatype: :binary,
      default: "localhost",
      doc: "DB host.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.hostname"
    ],
    "db.port": [
      env_var: "CAOS_TSDB_DB_PORT",
      commented: true,
      datatype: :integer,
      default: 3306,
      doc: "DB port.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.port"
    ],
    "db.pool_size": [
      env_var: "CAOS_TSDB_DB_POOL_SIZE",
      commented: true,
      datatype: :integer,
      default: 5,
      doc: "DB connection pool size.",
      hidden: false,
      to: "caos_tsdb.Elixir.CaosTsdb.Repo.pool_size"
    ],
    "auth.token_ttl": [
      env_var: "CAOS_TSDB_AUTH_TOKEN_TTL",
      commented: true,
      datatype: :integer,
      default: 86400,
      doc: "Token TTL in seconds.",
      hidden: false,
      to: "guardian.Elixir.Guardian.ttl"
    ],
    "auth.secret_key": [
      env_var: "CAOS_TSDB_AUTH_SECRET_KEY",
      commented: true,
      datatype: :binary,
      default: "<secret>",
      doc: "Token secret key.",
      hidden: false,
      to: "guardian.Elixir.Guardian.secret_key"
    ],
    "auth.identity.username": [
      env_var: "CAOS_TSDB_AUTH_IDENTITY_USERNAME",
      commented: true,
      datatype: :binary,
      default: "admin",
      doc: "Username",
      hidden: false,
      to: "caos_tsdb.Elixir.Auth.identity.username"
    ],
    "auth.identity.password": [
      env_var: "CAOS_TSDB_AUTH_IDENTITY_PASSWORD",
      commented: true,
      datatype: :binary,
      default: "ADMIN_PASS",
      doc: "Password",
      hidden: false,
      to: "caos_tsdb.Elixir.Auth.identity.password"
    ],
  ],
  transforms: [
    "guardian.Elixir.Guardian.ttl": fn conf ->
      conf
      |> Conform.Conf.get("guardian.Elixir.Guardian.ttl")
      |> Enum.map(fn {key, ttl} -> { ttl, :seconds } end)
      |> List.last
    end,
  ],
  validators: []
]
