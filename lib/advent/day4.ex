defmodule Advent.Day4 do
  @moduledoc """
  # Day 4: Repose Record

  See: https://adventofcode.com/2018/day/4
  """

  @doc """
  ## Example

      iex> timestamps = [
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ]
      iex> Advent.Day4.guard_with_most_sleep_times_most_slept_minute(timestamps)
      240

  """
  def guard_with_most_sleep_times_most_slept_minute(timestamps) do
    guard_id = guard_with_max_sleep(timestamps)
    guard_id * most_slept_minute_for_guard(guard_id, timestamps)
  end

  @doc """
  ## Example

      iex> timestamps = [
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ]
      iex> Advent.Day4.most_slept_minute_for_guard(10, timestamps)
      24

  """
  def most_slept_minute_for_guard(id, timestamps) do
    timestamps
    |> guard_sleep_minutes()
    |> Map.get(id)
    |> Enum.flat_map(&Enum.to_list/1)
    |> Enum.group_by(& &1)
    |> Enum.sort_by(
      fn {minute, minutes} ->
        {minute, Enum.count(minutes)}
      end,
      fn {a1, b1}, {a2, b2} ->
        if b1 == b2, do: a1 <= a2, else: b1 > b2
      end
    )
    |> List.first()
    |> elem(0)
  end

  @doc """
  Gets the ID of the guard that slept the longest and multiplies it by the minutes slept.

  ## Example

      iex> Advent.Day4.guard_with_max_sleep([
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ])
      10

  """
  def guard_with_max_sleep(timestamps) do
    timestamps
    |> guard_sleep_minutes()
    |> Enum.map(fn {guard, ranges} ->
      total_minutes =
        ranges
        |> Enum.map(&Enum.count/1)
        |> Enum.sum()

      {guard, total_minutes}
    end)
    |> Enum.max_by(fn {_id, minutes} -> minutes end)
    |> elem(0)
  end

  @doc """
  ## Examples

      iex> Advent.Day4.guard_sleep_minutes([
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ])
      %{10 => [24..29, 30..55, 5..25], 99 => [45..55, 36..46, 40..50]}


  """
  def guard_sleep_minutes(timestamps) do
    {_, _, guards_sleeping} =
      timestamps
      |> Enum.sort()
      |> Enum.reduce({nil, nil, %{}}, fn t, {current_guard, started_sleep, sleep_minutes} ->
        with nil <- Regex.named_captures(~r/Guard #(?<id>\d+)/, t),
             nil <- Regex.named_captures(~r/00:(?<start>\d+)] falls asleep/, t),
             nil <- Regex.named_captures(~r/00:(?<end>\d+)] wakes up/, t) do
          {current_guard, started_sleep, sleep_minutes}
        else
          %{"id" => new_guard} ->
            {String.to_integer(new_guard), nil, sleep_minutes}

          %{"start" => min} ->
            {current_guard, String.to_integer(min), sleep_minutes}

          %{"end" => min} ->
            slept_for = started_sleep..String.to_integer(min)

            {current_guard, nil,
             Map.update(sleep_minutes, current_guard, [slept_for], &[slept_for | &1])}
        end
      end)

    guards_sleeping
  end

  @doc """
  Multiply Guard ID by msot slept minute.

  ## Example

      iex> timestamps = [
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ]
      iex> Advent.Day4.guard_id_times_most_slept_minute(timestamps)
      4455

  """
  def guard_id_times_most_slept_minute(timestamps) do
    {id, min} = minute_with_most_sleep(timestamps)
    id * min
  end

  @doc """
  ## Example

      iex> Advent.Day4.minute_with_most_sleep([
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ])
      {99, 45}

  """
  def minute_with_most_sleep(timestamps) do
    timestamps
    |> sleep_minutes()
    |> Enum.flat_map(fn {id, sleep_chunk} -> Enum.map(sleep_chunk, &{id, &1}) end)
    |> Enum.group_by(& &1)
    |> Enum.map(fn {{id, min}, mins} -> {{id, min}, Enum.count(mins)} end)
    |> Enum.sort(fn {a1, b1}, {a2, b2} -> if b1 == b2, do: a1 <= a2, else: b1 > b2 end)
    |> List.first()
    |> elem(0)
  end

  @doc """
  ## Example

      iex> Advent.Day4.sleep_minutes([
      ...>   "[1518-11-01 00:00] Guard #10 begins shift",
      ...>   "[1518-11-01 00:05] falls asleep",
      ...>   "[1518-11-01 00:25] wakes up",
      ...>   "[1518-11-01 00:30] falls asleep",
      ...>   "[1518-11-01 00:55] wakes up",
      ...>   "[1518-11-01 23:58] Guard #99 begins shift",
      ...>   "[1518-11-02 00:40] falls asleep",
      ...>   "[1518-11-02 00:50] wakes up",
      ...>   "[1518-11-03 00:05] Guard #10 begins shift",
      ...>   "[1518-11-03 00:24] falls asleep",
      ...>   "[1518-11-03 00:29] wakes up",
      ...>   "[1518-11-04 00:02] Guard #99 begins shift",
      ...>   "[1518-11-04 00:36] falls asleep",
      ...>   "[1518-11-04 00:46] wakes up",
      ...>   "[1518-11-05 00:03] Guard #99 begins shift",
      ...>   "[1518-11-05 00:45] falls asleep",
      ...>   "[1518-11-05 00:55] wakes up",
      ...> ])
      [{10, 24..29}, {10, 30..55}, {10, 5..25}, {99, 45..55}, {99, 36..46}, {99, 40..50}]

  """
  def sleep_minutes(timestamps) do
    {_, _, sleeping} =
      timestamps
      |> Enum.sort()
      |> Enum.reduce({nil, nil, []}, fn t, {current_guard, started_sleep, sleep_minutes} ->
        with nil <- Regex.named_captures(~r/Guard #(?<id>\d+)/, t),
             nil <- Regex.named_captures(~r/00:(?<start>\d+)] falls asleep/, t),
             nil <- Regex.named_captures(~r/00:(?<end>\d+)] wakes up/, t) do
          {current_guard, started_sleep, sleep_minutes}
        else
          %{"id" => new_guard} ->
            {String.to_integer(new_guard), nil, sleep_minutes}

          %{"start" => min} ->
            {current_guard, String.to_integer(min), sleep_minutes}

          %{"end" => min} ->
            slept_for = started_sleep..String.to_integer(min)
            {current_guard, nil, [{current_guard, slept_for} | sleep_minutes]}
        end
      end)

    Enum.sort_by(sleeping, fn {id, _minutes} -> id end)
  end
end
