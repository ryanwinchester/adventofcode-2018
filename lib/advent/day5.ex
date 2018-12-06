defmodule Advent.Day5 do
  @moduledoc """
  --- Day 5: Alchemical Reduction ---

  You've managed to sneak in to the prototype suit manufacturing lab. The Elves
  are making decent progress, but are still struggling with the suit's size
  reduction capabilities.

  While the very latest in 1518 alchemical technology might have solved their
  problem eventually, you can do better. You scan the chemical composition of
  the suit's material and discover that it is formed by extremely long polymers
  (one of which is available as your puzzle input).

  The polymer is formed by smaller units which, when triggered, react with each
  other such that two adjacent units of the same type and opposite polarity are
  destroyed. Units' types are represented by letters; units' polarity is
  represented by capitalization. For instance, r and R are units with the same
  type but opposite polarity, whereas r and s are entirely different types and
  do not react.

  For example:

    * In `aA`, `a` and `A` react, leaving nothing behind.
    * In `abBA`, `bB` destroys itself, leaving `aA`. As above, this then
      destroys itself, leaving nothing.
    * In `abAB`, no two adjacent units are of the same type, and so nothing
      happens.
    * In `aabAAB`, even though `aa` and `AA` are of the same type, their
      polarities match, and so nothing happens.

  Now, consider a larger example, `dabAcCaCBAcCcaDA`:

  `dabAcCaCBAcCcaDA`  The first 'cC' is removed.
  `dabAaCBAcCcaDA`    This creates 'Aa', which is removed.
  `dabCBAcCcaDA`      Either 'cC' or 'Cc' are removed (the result is the same).
  `dabCBAcaDA`        No further actions can be taken.

  After all possible reactions, the resulting polymer contains 10 units.

  How many units remain after fully reacting the polymer you scanned?

  --- Part Two ---

  Time to improve the polymer.

  One of the unit types is causing problems; it's preventing the polymer from
  collapsing as much as it should. Your goal is to figure out which unit type
  is causing the most problems, remove all instances of it (regardless of
  polarity), fully react the remaining polymer, and measure its length.

  For example, again using the polymer `dabAcCaCBAcCcaDA` from above:

    * Removing all `A/a` units produces `dbcCCBcCcD`. Fully reacting this polymer
      produces `dbCBcD`, which has length `6`.
    * Removing all `B/b` units produces `daAcCaCAcCcaDA`. Fully reacting this
      polymer produces `daCAcaDA`, which has length `8`.
    * Removing all `C/c` units produces `dabAaBAaDA`. Fully reacting this
      polymer produces `daDA`, which has length `4`.
    * Removing all `D/d` units produces `abAcCaCBAcCcaA`. Fully reacting this
      polymer produces `abCBAc`, which has length `6`.

  In this example, removing all `C/c` units was best, producing the answer `4`.

  What is the length of the shortest polymer you can produce by removing all
  units of exactly one type and fully reacting the result?

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
    |> Enum.reverse()
    |> Enum.reduce([""], fn unit, [prev_unit | tail] = acc ->
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
  Foo.

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
    |> String.codepoints()
    |> Enum.map(&String.downcase/1)
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
