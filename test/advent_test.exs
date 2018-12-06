defmodule AdventTest do
  use ExUnit.Case

  import Advent

  doctest Advent.Day1
  doctest Advent.Day2
  doctest Advent.Day3
  doctest Advent.Day4
  doctest Advent.Day5

  test "day_1_1", do: assert(day_1_1() == 510)
  test "day_1_2", do: assert(day_1_2() == 69074)

  test "day_2_1", do: assert(day_2_1() == 8398)
  test "day_2_2", do: assert(day_2_2() == "hhvsdkatysmiqjxunezgwcdpr")

  test "day_3_1", do: assert(day_3_1() == 101_196)
  test "day_3_2", do: assert(day_3_2() == 243)

  test "day_4_1", do: assert(day_4_1() == 21083)
  test "day_4_2", do: assert(day_4_2() == 53024)

  test "day_5_1", do: assert(day_5_1() == 11476)
  test "day_5_2", do: assert(day_5_2() == 5446)
end
