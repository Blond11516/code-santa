import Config

config :code_santa, ecto_repos: [CodeSanta.Repo]

import_config "#{config_env()}.exs"
