defmodule CodeSanta.AdventOfCode do
  @base_url "https://adventofcode.com"

  @spec puzzle_url(integer(), integer()) :: String.t()
  def puzzle_url(year, day) do
    Enum.join([@base_url, Integer.to_string(year), "day", Integer.to_string(day)], "/")
  end

  @spec to_absolute_url(String.t()) :: String.t()
  def to_absolute_url(relative_url), do: @base_url <> relative_url
end
