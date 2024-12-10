defmodule CodeSanta.Puzzle.Parser do
  alias CodeSanta.AdventOfCode
  alias CodeSanta.Puzzle

  @spec parse([Floki.html_node()]) :: [Puzzle.paragraph()]
  def parse(html_puzzle) do
    html_puzzle
    |> Enum.filter(fn
      {"p", [], ["\n"]} -> false
      "\n" -> false
      {_, _, _} -> true
    end)
    |> Enum.map(&parse_paragraph/1)
    |> dbg()
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
    title_attributes = Floki.attribute(node, "title")
    class_attributes = Floki.attribute(node, "class")

    cond do
      match?([_title], title_attributes) -> {:tooltip, hd(title_attributes), parse_text_node_list(children)}
      match?(["quiet"], class_attributes) -> {:quiet, parse_text_node_list(children)}
    end
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

  defp parse_text_node({"ul", _, children}) do
    {:list, parse_text_node_list(children)}
  end
end
