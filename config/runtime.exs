import Config
import CodeSanta.ConfigHelpers, only: [get_env: 3, get_env: 2, get_env: 1]

# Static config

config :code_santa, Oban,
  engine: Oban.Engines.Lite,
  repo: CodeSanta.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"0 0 23 11 *", CodeSanta.AdventScheduler}
     ],
     timezone: "EST"}
  ],
  queues: [puzzles: 1]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Dynamic config

config :code_santa,
  channel: get_env("CODE_SANTA_CHANNEL"),
  slack_api_token: get_env("CODE_SANTA_SLACK_API_KEY")

config :code_santa, CodeSanta.Repo, database: get_env("DATABASE_PATH")

if config_env() == :prod do
  config :code_santa, CodeSanta.Repo,
    socket_options: [:inet6],
    pool_size: get_env("POOL_SIZE", :integer, 10)
end
