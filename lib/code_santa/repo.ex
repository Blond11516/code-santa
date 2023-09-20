defmodule CodeSanta.Repo do
  use Ecto.Repo,
    otp_app: :code_santa,
    adapter: Ecto.Adapters.SQLite3
end
