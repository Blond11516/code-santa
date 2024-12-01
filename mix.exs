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
      {:req, "0.5.7"},
      {:floki, "0.36.3"},
      {:jason, "1.4.4"},
      {:oban, "2.18.3"},
      {:tzdata, "1.1.2"},
      {:ecto, "3.12.4"},
      {:ecto_sqlite3, "0.17.4"},
      {:castore, "1.0.10"},
      {:credo, "1.7.10", only: :dev, runtime: false},
      {:dialyxir, "1.4.4", only: :dev, runtime: false}
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
