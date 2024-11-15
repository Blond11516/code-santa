defmodule CodeSanta.Puzzle.Worker do
  use Oban.Worker, queue: :puzzles, unique: [period: :infinity]

  alias CodeSanta.Puzzle.Fetcher
  alias CodeSanta.Slack.Client, as: SlackClient

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"year" => year, "day" => day}}) do
    Logger.info("Handling job for year #{year} and day #{day}")

    year
    |> Fetcher.fetch_challenge!(day)
    |> tap(fn _ -> Logger.info("Fetched puzzle for day #{day}") end)
    |> SlackClient.post_puzzle()
    |> tap(fn _ -> Logger.info("Posted puzzle for day #{day}") end)

    :ok
  end

  @impl Oban.Worker
  def backoff(_), do: 600
end
