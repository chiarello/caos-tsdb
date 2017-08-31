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

use Mix.Config

# Values defined here, for the production environment, act as
# placeholders for caos_tsdb.conf, generated by conform.


# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
config :caos_tsdb, CaosTsdb.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :caos_tsdb, CaosTsdb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :caos_tsdb, CaosTsdb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
config :caos_tsdb, CaosTsdb.Endpoint, server: true

# You will also need to set the application root to `.` in order
# for the new static assets to be served after a hot upgrade:
config :caos_tsdb, CaosTsdb.Endpoint, root: "."

config :caos_tsdb, CaosTsdb.Endpoint,
  secret_key_base: :crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64)

# Configure your database
config :caos_tsdb, CaosTsdb.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "caos",
  password: "",
  database: "caos",
  hostname: "localhost",
  port: 3306,
  pool_size: 5
