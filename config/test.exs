use Mix.Config

# Configure your database
config :hayai_ledger, HayaiLedger.Repo,
  username: "erin",
  password: "postgres",
  database: "hayai_ledger_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hayai_ledger, HayaiLedgerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :argon2_elixir, t_cost: 1, m_cost: 8
