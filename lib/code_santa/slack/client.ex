defmodule CodeSanta.Slack.Client do
  alias CodeSanta.Puzzle
  alias CodeSanta.Slack.Formatter

  require Logger

  @spec post_puzzle(Puzzle.t()) :: :ok
  def post_puzzle(%Puzzle{} = puzzle) do
    puzzle_id = "#{puzzle.year}-#{puzzle.day}"

    blocks =
      puzzle
      |> Formatter.format()
      |> Jason.encode!()

      Logger.info("Successfully formatted puzzle #{puzzle_id}")

      channel_id = "#" <> Application.get_env(:code_santa, :channel)

      Logger.info("Will attempt to post puzzle #{puzzle_id} to Slack channel #{channel_id}")

    %{body: %{"ok" => true}} =
      Req.post!(
        "https://slack.com/api/chat.postMessage",
        json: %{
          "channel" => channel_id,
          "text" => Formatter.announcement_block(),
          "blocks" => blocks
        },
        headers: [
          {"content-type", "application/json; charset=utf-8"},
          {"authorization", "Bearer #{Application.get_env(:code_santa, :slack_api_token)}"}
        ]
      )

    :ok
  end
end
