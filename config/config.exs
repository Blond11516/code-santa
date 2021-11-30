import Config

config :code_santa, ecto_repos: [CodeSanta.Repo]

config :code_santa, Oban,
  repo: CodeSanta.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"0 0 30 11 *", CodeSanta.AdventScheduler}
     ],
     timezone: "EST"}
  ],
  queues: [puzzles: 1]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
