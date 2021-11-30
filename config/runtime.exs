import Config

env_file_name = ".env.#{Config.config_env()}"

if File.exists?(env_file_name) do
  DotenvParser.load_file(env_file_name)
end

config :code_santa, channel: CodeSantaConfig.channel()

config :code_santa, CodeSanta.Repo, url: CodeSantaConfig.database_url()

if config_env() == :prod do
  config :code_santa, CodeSanta.Repo,
    socket_options: [:inet6],
    pool_size: CodeSantaConfig.database_pool_size()
end
