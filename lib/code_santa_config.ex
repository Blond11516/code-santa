defmodule CodeSantaConfig do
  @spec slack_api_token :: String.t()
  def slack_api_token, do: System.fetch_env!("CODE_SANTA_SLACK_API_KEY")

  @spec channel :: String.t()
  def channel, do: System.fetch_env!("CODE_SANTA_CHANNEL")

  @spec database_url :: String.t()
  def database_url, do: System.fetch_env!("DATABASE_URL")

  @spec database_pool_size :: pos_integer()
  def database_pool_size, do: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
