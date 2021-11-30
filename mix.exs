defmodule CodeSanta.MixProject do
  use Mix.Project

  def project do
    [
      app: :code_santa,
      version: "0.1.0",
      elixir: "~> 1.12",
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
      {:req, "0.2.0"},
      {:floki, "0.32.0"},
      {:jason, "1.2.2"},
      {:oban, "2.10.1"},
      {:tzdata, "1.1.1"},
      {:dotenv_parser, "1.2.0", runtime: false},
      {:credo, "1.6.1", only: :dev, runtime: false},
      {:dialyxir, "1.1.0", only: :dev, runtime: false}
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
