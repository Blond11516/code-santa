import Config
import CodeSanta.ConfigHelpers, only: [get_env: 3, get_env: 2, get_env: 1]

env_file_name = ".env.#{Config.config_env()}"

if File.exists?(env_file_name) do
  DotenvParser.load_file(env_file_name)
end

config :code_santa,
  channel: get_env("CODE_SANTA_CHANNEL"),
  slack_api_token: get_env("CODE_SANTA_SLACK_API_KEY")

config :code_santa, CodeSanta.Repo, url: get_env("DATABASE_URL")

if config_env() == :prod do
  config :code_santa, CodeSanta.Repo,
    socket_options: [:inet6],
    pool_size: get_env("POOL_SIZE", :integer, 10)
end
