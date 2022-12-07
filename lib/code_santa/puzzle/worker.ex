defmodule CodeSanta.Puzzle.Worker do
  use Oban.Worker, queue: :puzzles, unique: [period: :infinity]

  alias CodeSanta.Puzzle.Fetcher
  alias CodeSanta.Slack.Client, as: SlackClient

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"year" => year, "day" => day}}) do
    year
    |> Fetcher.fetch_challenge!(day)
    |> SlackClient.post_puzzle()

    :ok
  end

  @impl Oban.Worker
  def backoff(_), do: 600
end
