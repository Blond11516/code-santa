import Config

config :code_santa, ecto_repos: [CodeSanta.Repo]

config :floki, :html_parser, Floki.HTMLParser.Html5ever

import_config "#{config_env()}.exs"
