# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pr_tool,
  ecto_repos: [PrTool.Repo]

# Configures the endpoint
config :pr_tool, PrToolWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+ssM0GcN0sVvczIjve3Ae9e5ooZzuTMZIR82dablr9w8hwq2ZDW/xtkLkROXpJMe",
  render_errors: [view: PrToolWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PrTool.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
