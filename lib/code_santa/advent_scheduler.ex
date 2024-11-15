defmodule CodeSanta.AdventScheduler do
  use Oban.Worker, queue: :puzzles

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    Logger.info("Scheduling all puzzle jobs")

    1..25
    |> Enum.each(&enqueue_puzzle_job/1)

    Logger.info("All puzzle jobs scheduled successfully")

    :ok
  end

  defp enqueue_puzzle_job(day) do
    Logger.info("Scheduling job for day #{day}")

    %{year: year} = Date.utc_today()

    start_on_date = Date.new!(year, 12, day)
    start_on_time = ~T[00:05:00]
    start_on = DateTime.new!(start_on_date, start_on_time, "EST")

    %{year: year, day: day}
    |> CodeSanta.Puzzle.Worker.new(scheduled_at: start_on)
    |> Oban.insert()
  end
end
