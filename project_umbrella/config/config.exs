# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :project,
  ecto_repos: [Project.Repo]

config :project_web,
  ecto_repos: [Project.Repo],
  generators: [context_app: :project]

# Configures the endpoint
config :project_web, ProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OLNjpm5raEh6eudv/Ie0pYCdG5QwHbFepn+PIEDreI67n9S4un0iDeU03OBQknjk",
  render_errors: [view: ProjectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ProjectWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "eD75bWU0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


config :project_web, ProjectWeb.Guardian,
  issuer: "project_web",
  secret_key: "9BlYtCYUdZpBDITT3TlC9JxMc8JP/2IL8EWSJb8mtVHT1AScZL5JapPHda3/0XKp"

config :project, ProjectWeb.Gettext,
  locales: ~w(en nl),
  default_locale: "en"

