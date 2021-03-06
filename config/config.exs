# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :vigilo, VigiloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "w4kfpQoTwQl0MNFTILU/jCtoJz6N/zorBtqVl5vllo4lF8386e8JF3s00/mRKN9V",
  render_errors: [view: VigiloWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Vigilo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "macs.secret.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
