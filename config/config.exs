# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :teal,
  ecto_repos: [Teal.Repo]

# Configures the endpoint
config :teal, Teal.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OqBxcD3DSXER5b6nyqmGsHCo/T/LNzorJnhWRcEy4jd8wPnxc2j27j661XBJAYqE",
  render_errors: [view: Teal.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Teal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
