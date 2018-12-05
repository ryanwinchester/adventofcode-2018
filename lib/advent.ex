defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  # ----------------------------------------------------------------------------
  # Day 1
  # ----------------------------------------------------------------------------

  def day_1_1 do
    "input1.txt"
    |> input_file_to_stream()
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
    |> Advent.Day1.final_frequency()
  end

  def day_1_2 do
    "input1.txt"
    |> input_file_to_stream()
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
    |> Advent.Day1.first_repeated_frequency()
  end

  # ----------------------------------------------------------------------------
  # Day 2
  # ----------------------------------------------------------------------------

  def day_2_1 do
    "input2.txt"
    |> input_file_to_stream()
    |> Enum.to_list()
    |> Advent.Day2.checksum()
  end

  def day_2_2 do
    "input2.txt"
    |> input_file_to_stream()
    |> Enum.to_list()
    |> Advent.Day2.common_chars()
  end

  # ----------------------------------------------------------------------------
  # Day 3
  # ----------------------------------------------------------------------------

  def day_3_1 do
    "input3.txt"
    |> input_file_to_stream()
    |> Enum.to_list()
    |> Advent.Day3.overlap_area()
  end

  def day_3_2 do
    "input3.txt"
    |> input_file_to_stream()
    |> Enum.to_list()
    |> Advent.Day3.intact_claim()
  end

  # ----------------------------------------------------------------------------
  # Day 4
  # ----------------------------------------------------------------------------

  def day_4_1 do
    "input4.txt"
    |> input_file_to_stream()
    |> Enum.to_list()
    |> Advent.Day4.guard_with_most_sleep_times_most_slept_minute()
  end

  def day_4_2 do
    "input4.txt"
    |> input_file_to_stream()
    |> Enum.to_list()
    |> Advent.Day4.guard_id_times_most_slept_minute()
  end

  # ----------------------------------------------------------------------------
  # Helpers
  # ----------------------------------------------------------------------------

  defp input_file_to_stream(filename) do
    filename
    |> Path.expand("priv/input")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
