defmodule Advent.Day2 do
  @moduledoc """
  # Day 2: Inventory Management System

  See: https://adventofcode.com/2018/day/2
  """

  @doc """
  A rudimentary checksum of string IDs.

  ## Examples

      iex(1)> Advent.Day2.checksum([
      ...(1)>   "abcdef",
      ...(1)>   "bababc",
      ...(1)>   "abbcde",
      ...(1)>   "abcccd",
      ...(1)>   "aabcdd",
      ...(1)>   "abcdee",
      ...(1)>   "ababab"
      ...(1)> ])
      12

  """
  @spec checksum([binary]) :: non_neg_integer

  def checksum(ids) do
    {twice_count, thrice_count} =
      ids
      |> Stream.map(&count_chars/1)
      |> Enum.reduce({0, 0}, fn {twice, thrice}, {acc_twice, acc_thrice} ->
        case {twice > 0, thrice > 0} do
          {true, true} -> {acc_twice + 1, acc_thrice + 1}
          {true, false} -> {acc_twice + 1, acc_thrice}
          {false, true} -> {acc_twice, acc_thrice + 1}
          _ -> {acc_twice, acc_thrice}
        end
      end)

    twice_count * thrice_count
  end

  @doc """
  Find the common characters between two IDs that differ by only one character
  in the same position.

  ## Example

      iex(1)> Advent.Day2.common_chars([
      ...(1)> "abcde",
      ...(1)> "fghij",
      ...(1)> "klmno",
      ...(1)> "pqrst",
      ...(1)> "fguij",
      ...(1)> "axcye",
      ...(1)> "wvxyz",
      ...(1)> ])
      "fgij"

  """
  @spec common_chars([binary]) :: binary

  def common_chars(ids) do
    for i <- ids, j <- ids do
      String.myers_difference(i, j)
    end
    |> Enum.filter(&differs_by_one?/1)
    |> Enum.at(0)
    |> Keyword.get_values(:eq)
    |> Enum.join("")
  end

  defp count_chars(id) do
    occurances =
      id
      |> String.codepoints()
      |> Enum.reduce(%{}, fn letter, acc ->
        Map.update(acc, letter, 1, &(&1 + 1))
      end)

    twice_count =
      occurances
      |> Enum.filter(fn {_k, v} -> v == 2 end)
      |> Enum.count()

    thrice_count =
      occurances
      |> Enum.filter(fn {_k, v} -> v == 3 end)
      |> Enum.count()

    {twice_count, thrice_count}
  end

  defp differs_by_one?(diff) do
    inserts = Keyword.get_values(diff, :ins)
    ins = List.first(inserts)
    dels = Keyword.get_values(diff, :del)
    del = List.first(dels)

    one_ins? = length(inserts) == 1 and String.length(ins) == 1
    one_del? = length(dels) == 1 and String.length(del) == 1

    one_del? and one_ins?
  end
end
