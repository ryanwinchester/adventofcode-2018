defmodule Advent.Day5 do
  @moduledoc """
  # Day 5: Alchemical Reduction

  See description: https://adventofcode.com/2018/day/5
  """

  @doc """
  Count the units left after a complete reaction of the polymer.

  ## Example

      iex> Advent.Day5.unreacted_units_count("dabAcCaCBAcCcaDA")
      10

  """
  def unreacted_units_count(polymer) do
    react(polymer) |> String.length()
  end

  @doc """
  Return the final polymer after all reactions complete.

  ## Example

      iex> Advent.Day5.react("dabAcCaCBAcCcaDA")
      "dabCBAcaDA"

  """
  def react(polymer) do
    polymer
    |> String.codepoints()
    |> List.foldr([""], fn unit, [prev_unit | tail] = acc ->
      if reacts?(unit, prev_unit), do: tail, else: [unit | acc]
    end)
    |> Enum.join()
  end

  @doc """
  Check if two units react with eachother.

  ## Examples

      iex> Advent.Day5.reacts?("a", "A")
      true

      iex> Advent.Day5.reacts?("b", "b")
      false

      iex> Advent.Day5.reacts?("B", "c")
      false

  """
  def reacts?(c1, c2) do
    c1 != c2 and String.downcase(c1) == String.downcase(c2)
  end

  @doc """
  Calculate the best possible polymer length after stripping each unique unit
  and reacting each result.

  ## Example

      iex> Advent.Day5.best_possible_polymer_length("dabAcCaCBAcCcaDA")
      4

  """
  def best_possible_polymer_length(polymer) do
    polymer
    |> unique_units()
    |> Enum.map(&strip_units(polymer, &1))
    |> Enum.map(&unreacted_units_count/1)
    |> Enum.min()
  end

  @doc """
  Reduce a polymer to a list of unique units (without polarity).

  ## Example

      iex> Advent.Day5.unique_units("dabAcCaCBAcCcaDA")
      ["d", "a", "b", "c"]

  """
  def unique_units(polymer) do
    polymer
    |> String.downcase()
    |> String.codepoints()
    |> Enum.uniq()
  end

  @doc """
  Strip a unit from a polymer.

  ## Example

      iex> Advent.Day5.strip_units("dabAcCaCBAcCcaDA", "a")
      "dbcCCBcCcD"

  """
  def strip_units(polymer, unit) do
    String.replace(polymer, ~r/[#{String.downcase(unit)}#{String.upcase(unit)}]/, "")
  end
end
