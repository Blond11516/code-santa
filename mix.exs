defmodule CodeSanta.MixProject do
  use Mix.Project

  def project do
    [
      app: :code_santa,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {CodeSanta, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "0.4.5"},
      {:floki, "0.35.2"},
      {:jason, "1.4.1"},
      {:oban, "2.16.3"},
      {:tzdata, "1.1.1"},
      {:ecto, "3.10.3"},
      {:ecto_sqlite3, "0.12.0"},
      {:dotenv_parser, "2.0.0", runtime: false},
      {:credo, "1.7.1", only: :dev, runtime: false},
      {:dialyxir, "1.4.2", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      lint: ["format --check-formatted", "credo --strict", "dialyzer"]
    ]
  end
end
