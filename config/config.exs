# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cache_db_test,
  ecto_repos: [CacheDbTest.Repo]

# Configures the endpoint
config :cache_db_test, CacheDbTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3J3dB2GgeUsZUOy5mTnG3g/daK5iE35QsixyYZNmbtdSeZa9sBOlWIhS9HeokSok",
  render_errors: [view: CacheDbTestWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: CacheDbTest.PubSub,
  live_view: [signing_salt: "1ESOFyc+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
