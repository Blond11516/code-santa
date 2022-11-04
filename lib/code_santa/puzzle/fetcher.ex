defmodule CodeSanta.Puzzle.Fetcher do
  alias CodeSanta.AdventOfCode
  alias CodeSanta.Puzzle

  @spec fetch_challenge!(integer(), integer()) :: Puzzle.t()
  def fetch_challenge!(year, day) when is_integer(year) and is_integer(day) do
    puzzle_link = AdventOfCode.puzzle_url(year, day)

    puzzle_link
    |> Req.get!()
    |> handle_response(year, day)
  end

  @spec handle_response(Req.Response.t(), integer(), integer()) :: Puzzle.t()
  defp handle_response(%Req.Response{status: 200} = response, year, day) do
    document = Floki.parse_document!(response.body)

    title = get_title(document)
    description = get_description(document)

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
    |> Enum.map(&parse_paragraph/1)
  end

  @spec parse_paragraph(Floki.html_node()) :: Puzzle.paragraph()
  defp parse_paragraph({"p", _, children}) do
    parse_text_node_list(children)
  end

  defp parse_paragraph({"pre", _, [{"code", _, children}]}) do
    {:code_block, parse_text_node_list(children)}
  end

  defp parse_paragraph({"ul", _, children}),
    do: {:list, Enum.map(List.wrap(children), &parse_text_node/1)}

  @spec parse_text_node_list([Floki.html_node()]) :: [Puzzle.text_node()]
  defp parse_text_node_list(nodes), do: Enum.map(nodes, &parse_text_node/1)

  @spec parse_text_node(Floki.html_node()) :: Puzzle.text_node()
  defp parse_text_node(text) when is_binary(text), do: text

  defp parse_text_node({"span", _, children} = node) do
    [title] = Floki.attribute(node, "title")

    {:tooltip, title, parse_text_node_list(children)}
  end

  defp parse_text_node({"a", _, [text]} = node) do
    [link] = Floki.attribute(node, "href")

    link =
      if String.starts_with?(link, "/") do
        AdventOfCode.to_absolute_url(link)
      else
        link
      end

    {:link, link, text}
  end

  defp parse_text_node({"em", _, children} = node) do
    case Floki.attribute(node, "class") do
      ["star"] -> {:star, hd(children)}
      _ -> {:emphasis, parse_text_node_list(children)}
    end
  end

  defp parse_text_node({"code", _, children}) do
    {:code_snippet, parse_text_node_list(children)}
  end

  defp parse_text_node({"li", _, children}) do
    {:list_item, parse_text_node_list(children)}
  end
end
