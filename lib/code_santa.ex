defmodule CodeSanta do
  use Application

  @spec start(Application.start_type(), keyword()) :: {:ok, pid}
  def start(_type, _args) do
    events = [[:oban, :job, :start], [:oban, :job, :stop], [:oban, :job, :exception]]

    :telemetry.attach_many("oban-logger", events, &CodeSanta.ObanLogger.handle_event/4, [])
    :ok = Oban.Telemetry.attach_default_logger()

    children = [
      # CodeSanta.Repo,
      # {Oban, oban_config()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: CodeSanta.Supervisor)
  end

  defp oban_config do
    Application.fetch_env!(:code_santa, Oban)
  end
end
