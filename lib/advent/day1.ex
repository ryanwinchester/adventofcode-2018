defmodule Advent.Day1 do
  @moduledoc """
  # Day 1: Chronal Calibration

  See: https://adventofcode.com/2018/day/1
  """

  @doc """
  Sum all the frequency offsets to get the final frequency.

  ## Examples

      iex> Advent.Day1.final_frequency([+1, +1, +1])
      3

      iex> Advent.Day1.final_frequency([+1, +1, -2])
      0

      iex> Advent.Day1.final_frequency([-1, -2, -3])
      -6

  """
  @spec final_frequency([integer]) :: integer

  def final_frequency(frequencies) do
    Enum.sum(frequencies)
  end

  @doc """
  Cycle through the frequency offsets until you find the first repeated
  frequency.

  ## Examples

      iex> Advent.Day1.first_repeated_frequency([+1, -1])
      0

      iex> Advent.Day1.first_repeated_frequency([+3, +3, +4, -2, -4])
      10

      iex> Advent.Day1.first_repeated_frequency([-6, +3, +8, +5, -6])
      5

      iex> Advent.Day1.first_repeated_frequency([+7, +7, -2, -7, -4])
      14

  """
  @spec first_repeated_frequency([integer]) :: integer

  def first_repeated_frequency(frequency_offsets) do
    frequency_offsets
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {current_frequency, past_frequencies} ->
      new_freq = x + current_frequency

      if MapSet.member?(past_frequencies, new_freq) do
        {:halt, {new_freq, past_frequencies}}
      else
        {:cont, {new_freq, MapSet.put(past_frequencies, new_freq)}}
      end
    end)
    |> elem(0)
  end
end
