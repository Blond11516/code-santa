defmodule CodeSanta.Slack.Formatter do
  alias CodeSanta.AdventOfCode
  alias CodeSanta.Puzzle

  @announcement_block "HO! HO! HO! Un nouveau puzzle de l'Avent est arrivé! Sauras-tu le résoudre?"

  @type slack_paragraph :: %{
          String.t() => String.t(),
          String.t() => %{String.t() => String.t(), String.t() => String.t()}
        }

  @spec announcement_block() :: String.t()
  def announcement_block, do: @announcement_block

  @spec format(Puzzle.t()) :: [slack_paragraph()]
  def format(%Puzzle{} = puzzle) do
    puzzle_url = AdventOfCode.puzzle_url(puzzle.year, puzzle.day)

    [title_block] =
      puzzle.title
      |> make_link(puzzle_url)
      |> wrap_text_node("*")
      |> make_block()

    [announcement_block] = make_block(@announcement_block, type: :header)

    description_blocks = Enum.flat_map(puzzle.description, &format_paragraph/1)

    [announcement_block, title_block | description_blocks]
  end

  @spec format_paragraph(Puzzle.paragraph()) :: [slack_paragraph()]
  defp format_paragraph({:code_block, text_nodes}) do
    text = to_raw_text(text_nodes)

    make_block("```#{text}```")
  end

  defp format_paragraph({:list, text_nodes}) do
    text_nodes
    |> Enum.map(&format_text/1)
    |> Enum.map_join("\n", fn text -> "• " <> text end)
    |> make_block()
  end

  defp format_paragraph(text_nodes) do
    text_nodes
    |> format_text()
    |> make_block()
  end

  @spec format_text(Puzzle.text_node()) :: String.t()
  defp format_text(text) when is_binary(text), do: text
  defp format_text({:star, children}), do: wrap_text_node(children, "⭐ _")
  defp format_text({:emphasis, children}), do: wrap_text_node(children, "*")
  defp format_text({:tooltip, _, children}), do: format_text(children)
  defp format_text({:quiet, children}), do: format_text(children)
  defp format_text({:list_item, children}), do: format_text(children)

  defp format_text({:list, children}) do
    children
    |> Enum.map(&format_text/1)
    |> Enum.map_join("\n", fn text -> "    • " <> text end)
    |> String.replace(~r/^  /, "")
  end

  defp format_text({:link, link, children}) do
    formatted_children = format_text(children)

    make_link(formatted_children, link)
  end

  defp format_text({:code_snippet, children}) do
    formatted_node = wrap_text_node(children, "`")

    # Bold code snippets should have the stars on the inside to ensure proper formatting
    if String.starts_with?(formatted_node, "`*") and String.ends_with?(formatted_node, "*`") do
      formatted_node
      |> String.replace_prefix("`*", "*`")
      |> String.replace_suffix("*`", "`*")
    else
      formatted_node
    end
  end

  defp format_text(nodes) when is_list(nodes) do
    Enum.map_join(nodes, &format_text/1)
  end

  @spec wrap_text_node(Puzzle.text_node(), String.t()) :: String.t()
  defp wrap_text_node(node, wrapper) do
    prefix = wrapper
    suffix = String.reverse(wrapper)

    "#{prefix}#{format_text(node)}#{suffix}"
  end

  @spec make_block(String.t(), keyword()) :: [slack_paragraph()]
  defp make_block(text, opts \\ []) when is_binary(text) do
    case opts[:type] do
      :header -> [make_header_block(text)]
      _ -> make_section_block(text)
    end
  end

  @spec make_header_block(String.t()) :: slack_paragraph()
  defp make_header_block(text) do
    %{"type" => "header", "text" => %{"type" => "plain_text", "text" => text}}
  end

  @spec make_section_block(String.t()) :: [slack_paragraph()]
  defp make_section_block(text) do
    if String.length(text) > 3000 do
      {first, second} =
        case String.split_at(text, 2000) do
          {"```" <> first, second} -> {"```#{first}```", "```#{second}"}
          splits -> splits
        end

      [
        %{
          "type" => "context",
          "elements" => [
            %{
              "type" => "plain_text",
              "text" =>
                "Le bloc suivant a été coupé en 2 parce qu'il dépasse la limite de 3000 caractères imposée par Slack."
            }
          ]
        },
        %{"type" => "section", "text" => %{"type" => "mrkdwn", "text" => first}},
        %{"type" => "section", "text" => %{"type" => "mrkdwn", "text" => second}}
      ]
    else
      [%{"type" => "section", "text" => %{"type" => "mrkdwn", "text" => text}}]
    end
  end

  @spec make_link(String.t(), String.t()) :: String.t()
  defp make_link(text, link), do: "<#{link}|#{text}>"

  @spec to_raw_text(Puzzle.text_node()) :: String.t()
  defp to_raw_text(nodes) when is_list(nodes) do
    nodes
    |> Enum.map(&to_raw_text/1)
    |> List.flatten()
    |> Enum.join()
  end

  defp to_raw_text(text) when is_binary(text), do: text
  defp to_raw_text({_, children}), do: to_raw_text(children)
  defp to_raw_text({_, _, children}), do: to_raw_text(children)
end
