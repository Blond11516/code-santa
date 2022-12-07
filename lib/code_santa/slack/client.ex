defmodule CodeSanta.Slack.Client do
  alias CodeSanta.Puzzle
  alias CodeSanta.Slack.Formatter

  @spec post_puzzle(Puzzle.t()) :: :ok
  def post_puzzle(%Puzzle{} = puzzle) do
    channel_id = "#" <> Application.get_env(:code_santa, :channel)

    blocks =
      puzzle
      |> Formatter.format()
      |> IO.inspect(label: "before encode")
      |> Jason.encode!()

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
