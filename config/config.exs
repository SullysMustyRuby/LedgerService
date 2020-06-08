# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hayai_ledger,
  ecto_repos: [HayaiLedger.Repo]

# Configures the endpoint
config :hayai_ledger, HayaiLedgerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h50b6sO5A2MVlFran2AwjSuS3p3/CXpDPevp+IHO434I3KS/2mSUR+/HGQ8LCVgd",
  render_errors: [view: HayaiLedgerWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: HayaiLedger.PubSub,
	live_view: [
	 signing_salt: "7zbxLn36r/bDZsksrqbvV7U07tgdUXxZ"
	]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
