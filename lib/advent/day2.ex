defmodule Advent.Day2 do
  @moduledoc """
  --- Day 2: Inventory Management System ---

  You stop falling through time, catch your breath, and check the screen on the
  device. "Destination reached. Current Year: 1518. Current Location: North Pole
  Utility Closet 83N10." You made it! Now, to find those anomalies.

  Outside the utility closet, you hear footsteps and a voice. "...I'm not sure
  either. But now that so many people have chimneys, maybe he could sneak in
  that way?" Another voice responds, "Actually, we've been working on a new kind
  of suit that would let him fit through tight spaces like that. But, I heard
  that a few days ago, they lost the prototype fabric, the design plans,
  everything! Nobody on the team can even seem to remember important details of
  the project!"

  "Wouldn't they have had enough fabric to fill several boxes in the warehouse?
  They'd be stored together, so the box IDs should be similar. Too bad it would
  take forever to search the warehouse for two similar box IDs..." They walk too
  far away to hear any more.

  Late at night, you sneak to the warehouse - who knows what kinds of paradoxes
  you could cause if you were discovered - and use your fancy wrist device to
  quickly scan every box and produce a list of the likely candidates (your
  puzzle input).

  To make sure you didn't miss any, you scan the likely candidate boxes again,
  counting the number that have an ID containing exactly two of any letter and
  then separately counting those with exactly three of any letter. You can
  multiply those two counts together to get a rudimentary checksum and compare
  it to what your device predicts.

  For example, if you see the following box IDs:

    `abcdef` contains no letters that appear exactly two or three times.
    `bababc` contains two `a` and three `b`, so it counts for both.
    `abbcde` contains two `b`, but no letter appears exactly three times.
    `abcccd` contains three `c`, but no letter appears exactly two times.
    `aabcdd` contains two `a` and two `d`, but it only counts once.
    `abcdee` contains two `e`.
    `ababab` contains three `a` and three `b`, but it only counts once.

  Of these box IDs, four of them contain a letter which appears exactly twice,
  and three of them contain a letter which appears exactly three times.
  Multiplying these together produces a checksum of `4 * 3 = 12`.

  What is the checksum for your list of box IDs?

  --- Part Two ---

  Confident that your list of box IDs is complete, you're ready to find the
  boxes full of prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same
  position in both strings. For example, given the following box IDs:

      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz

  The IDs `abcde` and `axcye` are close, but they differ by two characters (the
  second and fourth). However, the IDs `fghij` and `fguij` differ by exactly one
  character, the third (`h` and `u`). Those must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example
  above, this is found by removing the differing character from either ID,
  producing `fgij`.)

  """

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
