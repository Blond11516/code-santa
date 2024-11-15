defmodule CodeSanta.Puzzle.Fetcher do
  alias CodeSanta.AdventOfCode
  alias CodeSanta.Puzzle
  alias CodeSanta.Puzzle.Parser

  require Logger

  @spec fetch_challenge!(integer(), integer()) :: Puzzle.t()
  def fetch_challenge!(year, day) when is_integer(year) and is_integer(day) do
    puzzle_link = AdventOfCode.puzzle_url(year, day)

    Logger.info("Will attempt to fetch AoC puzzle with link #{puzzle_link}")

    puzzle_link
    |> Req.get!()
    |> handle_response(year, day)
  end

  @spec handle_response(Req.Response.t(), integer(), integer()) :: Puzzle.t()
  defp handle_response(%Req.Response{status: 200} = response, year, day) do
    document = Floki.parse_document!(response.body)

    title = get_title(document)
    Logger.info("Fetched puzzle with title #{title}")
    description = get_description(document)
    Logger.info("Successfully parsed challenge description")

    %Puzzle{title: title, description: description, year: year, day: day}
  end

  @spec get_title(Floki.html_tree()) :: String.t()
  defp get_title(document) do
    document
    |> Floki.find("h2")
    |> Floki.text()
  end

  @spec get_description(Floki.html_tree()) :: [Puzzle.paragraph()]
  defp get_description(document) do
    document
    |> Floki.find(".day-desc")
    |> hd()
    |> Floki.children()
    |> Floki.filter_out("h2")
    |> Parser.parse()
  end
end
