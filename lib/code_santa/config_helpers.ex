defmodule CodeSanta.ConfigHelpers do
  @type config_type :: :string | :integer | :boolean | :json

  @doc """
  Get value from environment variable, converting it to the given type if needed.

  If no default value is given, or `:no_default` is given as the default, an error is raised if the variable is not
  set.
  """
  @spec get_env(String.t(), config_type(), :no_default | any()) :: any()
  def get_env(var, type \\ :string, default \\ :no_default)

  def get_env(var, type, :no_default) do
    System.fetch_env!(var)
    |> get_with_type(type)
  end

  def get_env(var, type, default) do
    case System.fetch_env(var) do
      {:ok, val} -> get_with_type(val, type)
      _ -> default
    end
  end

  @spec get_with_type(String.t(), config_type()) :: any()
  defp get_with_type(val, type)

  defp get_with_type(val, :string), do: val
  defp get_with_type(val, :integer), do: String.to_integer(val)
  defp get_with_type("true", :boolean), do: true
  defp get_with_type("false", :boolean), do: false
  defp get_with_type(val, :json), do: Jason.decode!(val)
  defp get_with_type(val, type), do: raise("Cannot convert to #{inspect(type)}: #{inspect(val)}")
end
