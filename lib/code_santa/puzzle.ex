defmodule CodeSanta.Puzzle do
  @enforce_keys [:title, :description, :year, :day]
  defstruct [:title, :description, :year, :day]

  @type code_paragraph :: {:code_block, [text_node()]}
  @type text_paragraph :: [text_node()]
  @type list_paragraph :: {:list, [text_paragraph()]}
  @type paragraph :: code_paragraph() | text_paragraph() | list_paragraph()

  @type text_node_value :: String.t() | [text_node()]
  @type text_node ::
          String.t()
          | {:star, text_node_value()}
          | {:emphasis, text_node_value()}
          | {:code_snippet, text_node_value()}
          | {:link, String.t(), text_node_value()}
          | {:tooltip, String.t(), text_node_value()}
          | {:list_item, text_node_value()}

  @type t :: %__MODULE__{
          title: String.t(),
          description: [paragraph()],
          year: integer(),
          day: integer()
        }
end
