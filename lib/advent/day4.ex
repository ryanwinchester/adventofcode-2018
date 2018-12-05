defmodule Advent.Day4 do
  @moduledoc """
  --- Day 4: Repose Record ---

  You've sneaked into another supply closet - this time, it's across from the
  prototype suit manufacturing lab. You need to sneak inside and fix the issues
  with the suit, but there's a guard stationed outside the lab, so this is as
  close as you can safely get.

  As you search the closet for anything that might help, you discover that
  you're not the first person to want to sneak in. Covering the walls, someone
  has spent an hour starting every midnight for the past few months secretly
  observing this guard post! They've been writing down the ID of the one guard
  on duty that night - the Elves seem to have decided that one guard was enough
  or the overnight shift - as well as when they fall asleep or wake up while at
  their post (your puzzle input).

  For example, consider the following records, which have already been organized
  into chronological order:

      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up

  Timestamps are written using `year-month-day hour:minute` format. The guard
  falling asleep or waking up is always the one whose shift most recently
  started. Because all asleep/awake times are during the midnight hour (`00:00`
  - `00:59`), only the minute portion (`00` - `59`) is relevant for those
  events.

  Visually, these records show that the guards are asleep at these times:

      Date   ID   Minute
                  000000000011111111112222222222333333333344444444445555555555
                  012345678901234567890123456789012345678901234567890123456789
      11-01  #10  .....####################.....#########################.....
      11-02  #99  ........................................##########..........
      11-03  #10  ........................#####...............................
      11-04  #99  ....................................##########..............
      11-05  #99  .............................................##########.....

  The columns are Date, which shows the month-day portion of the relevant day;
  ID, which shows the guard on duty that day; and Minute, which shows the
  minutes during which the guard was asleep within the midnight hour. (The
  Minute column's header shows the minute's ten's digit in the first row and the
  one's digit in the second row.) Awake is shown as `.`, and asleep is shown as
  `#`.

  Note that guards count as asleep on the minute they fall asleep, and they
  count as awake on the minute they wake up. For example, because Guard #10
  wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

  If you can figure out the guard most likely to be asleep at a specific time,
  you might be able to trick that guard into working tonight so you can have the
  best chance of sneaking in. You have two strategies for choosing the best
  guard/minute combination.

  Strategy 1: Find the guard that has the most minutes asleep. What minute does
  that guard spend asleep the most?

  In the example above, Guard #10 spent the most minutes asleep, a total of 50
  minutes (20+25+5), while Guard #99 only slept for a total of 30 minutes
  (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas
  any other minute the guard was asleep was only seen on one day).

  While this example listed the entries in chronological order, your entries are
  in the order you found them. You'll need to organize them before they can be
  analyzed.

  What is the ID of the guard you chose multiplied by the minute you chose? (In
  the above example, the answer would be `10 * 24 = 240`.)

  --- Part Two ---

  Strategy 2: Of all guards, which guard is most frequently asleep on the same
  minute?

  In the example above, Guard #99 spent minute 45 asleep more than any other
  guard or minute - three times in total. (In all other cases, any guard spent
  any minute asleep at most twice.)

  What is the ID of the guard you chose multiplied by the minute you chose? (In
  the above example, the answer would be `99 * 45 = 4455`.)

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
        |> Enum.map(&(Enum.at(&1, -1) - Enum.at(&1, 0)))
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
    |> Enum.flat_map(fn {id, sleep_chunk} -> Enum.map(sleep_chunk, &({id, &1})) end)
    |> Enum.group_by(& &1)
    |> Enum.map(fn {{id, min}, mins} -> {{id, min}, Enum.count(mins)} end)
    |> Enum.sort(
      fn {a1, b1}, {a2, b2} -> if b1 == b2, do: a1 <= a2, else: b1 > b2 end
    )
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
