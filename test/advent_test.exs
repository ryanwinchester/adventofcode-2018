defmodule AdventTest do
  use ExUnit.Case

  # ----------------------------------------------------------------------------
  # Day 1
  # ----------------------------------------------------------------------------

  describe "Day 1" do
    import Advent.Day1

    test "final_frequency" do
      assert final_frequency([-1, -1, +1]) == -1
      assert final_frequency([-1, -1, -1]) == -3
      assert final_frequency([-1, -1, +4]) == 2
    end

    test "first_repeated_frequency" do
      assert first_repeated_frequency([+1, -1]) == 0
      assert first_repeated_frequency([+3, +3, +4, -2, -4]) == 10
      assert first_repeated_frequency([-6, +3, +8, +5, -6]) == 5
      assert first_repeated_frequency([+7, +7, -2, -7, -4]) == 14
    end
  end

  # ----------------------------------------------------------------------------
  # Day 2
  # ----------------------------------------------------------------------------

  describe "Day 2" do
    import Advent.Day2

    test "checksum" do
      assert checksum([
        "abcdef",
        "bababc",
        "abbcde",
        "abcccd",
        "aabcdd",
        "abcdee",
        "ababab"
      ]) == 12
    end

    test "common_chars" do
      assert common_chars([
        "abcde",
        "fghij",
        "klmno",
        "pqrst",
        "fguij",
        "axcye",
        "wvxyz",
      ]) == "fgij"
    end
  end

  # ----------------------------------------------------------------------------
  # Day 3
  # ----------------------------------------------------------------------------

  describe "Day 3" do
    import Advent.Day3

    test "overlap_area" do
      assert overlap_area([
        "#1 @ 1,3: 4x4",
        "#2 @ 3,1: 4x4",
        "#3 @ 5,5: 2x2",
      ]) == 4
    end
  end
end
