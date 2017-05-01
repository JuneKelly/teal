use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :teal, Teal.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :teal, Teal.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "teal",
  password: "teal",
  database: "teal_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
