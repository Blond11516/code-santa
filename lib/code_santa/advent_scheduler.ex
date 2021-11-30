defmodule CodeSanta.AdventScheduler do
  use Oban.Worker, queue: :puzzles

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    1..25
    |> Enum.each(&enqueue_puzzle_job/1)

    :ok
  end

  defp enqueue_puzzle_job(day) do
    %{year: year} = Date.utc_today()

    start_on_date = Date.new!(year, 12, day)
    start_on_time = ~T[00:05:00]
    start_on = DateTime.new!(start_on_date, start_on_time, "EST")

    %{year: year, day: day}
    |> CodeSanta.Puzzle.Worker.new(scheduled_at: start_on)
    |> Oban.insert()
  end
end
