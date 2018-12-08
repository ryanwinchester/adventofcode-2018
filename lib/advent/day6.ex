defmodule Advent.Day6 do
  @moduledoc """
  # --- Day 6: Chronal Coordinates ---

  See: https://adventofcode.com/2018/day/6

  """

  @doc """
  ## Example

      iex> Advent.Day6.largest_non_infinite_area([
      ...>   {1, 1},
      ...>   {1, 6},
      ...>   {8, 3},
      ...>   {3, 4},
      ...>   {5, 5},
      ...>   {8, 9},
      ...> ])
      17

  """
  def largest_non_infinite_area(points) do
    bounding_box = bounding_box(points)
    grid = grid(bounding_box, points)
    points_with_infinite_areas = infinite_points(grid, bounding_box)

    grid
    |> Enum.sort()
    |> Enum.map(fn {_p, {_d, p}} -> p end)
    |> Enum.reject(&(is_nil(&1) or &1 in points_with_infinite_areas))
    |> Enum.group_by(& &1)
    |> Enum.map(fn {_, ids} -> Enum.count(ids) end)
    |> Enum.max()
  end

  @doc """
  Finds the Manhattan distance between two points (Taxicab geometry).

  ## Example

      iex> Advent.Day6.manhattan_distance({2, 3}, {4, 8})
      7

  """
  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  @doc """
  Get the bounding box for the working area of the grid.

  ## Example

      iex> Advent.Day6.bounding_box([
      ...>   {1, 1},
      ...>   {1, 6},
      ...>   {8, 3},
      ...>   {3, 4},
      ...>   {5, 5},
      ...>   {8, 9},
      ...> ])
      {1..8, 1..9}

  """
  def bounding_box(points) do
    [{x_min, x_max}, {y_min, y_max}] =
      points
      |> Enum.unzip()
      |> Tuple.to_list()
      |> Enum.map(&Enum.min_max/1)

    {x_min..x_max, y_min..y_max}
  end

  # Every labeled point that touches an edge of the partial grid...
  @doc """
  Get the list of points that have infinite areas.

  ## Example

      iex> grid = Advent.Day6.grid({1..8, 1..9}, [
      ...>   {1, 1},
      ...>   {1, 6},
      ...>   {8, 3},
      ...>   {3, 4},
      ...>   {5, 5},
      ...>   {8, 9},
      ...> ])
      iex> Advent.Day6.infinite_points(grid, {1..8, 1..9})
      [{8, 3}, {1, 6}, {8, 9}, {1, 1}]

  """
  def infinite_points(grid, {x_range, y_range}) do
    points =
      for {{x, y}, {_, point}} <- grid,
          x == x_range.first or x == x_range.last or y == y_range.first or y == y_range.last,
          do: point

    points
    |> Enum.uniq()
    |> Enum.filter(& &1)
  end

  @doc """
  Builds a map representing a grid.
  """
  def grid({x_range, y_range}, points) do
    for x <- x_range, y <- y_range, into: %{} do
      [min1 | [min2]] =
        points
        |> Enum.map(&{manhattan_distance(&1, {x, y}), &1})
        |> Enum.sort_by(fn {d, _} -> d end)
        |> Enum.take(2)

      case {min1, min2} do
        {{d, _}, {d, _}} ->
          {{x, y}, {d, nil}}

        _ ->
          {{x, y}, min1}
      end
    end
  end

  @doc """
  Builds a grid of sums less than a number.

  ## Example

      iex> Advent.Day6.area_of_sums_less_than([
      ...>   {1, 1},
      ...>   {1, 6},
      ...>   {8, 3},
      ...>   {3, 4},
      ...>   {5, 5},
      ...>   {8, 9},
      ...> ], 32)
      16

  """
  def area_of_sums_less_than(points, less_than) do
    grid_of_sums_less_than(points, less_than)
    |> Enum.count()
  end

  @doc """
  Builds a grid of sums less than a number.

  ## Example

      iex> Advent.Day6.grid_of_sums_less_than([
      ...>   {1, 1},
      ...>   {1, 6},
      ...>   {8, 3},
      ...>   {3, 4},
      ...>   {5, 5},
      ...>   {8, 9},
      ...> ], 29)
      [{{4, 4}, 28}, {{5, 5}, 28}, {{3, 4}, 28}, {{3, 5}, 28}, {{5, 4}, 28}, {{4, 5}, 28}]

  """
  def grid_of_sums_less_than(points, less_than) do
    points
    |> bounding_box()
    |> grid_of_sums(points)
    |> Enum.filter(fn {_p, sum} -> sum < less_than end)
  end

  @doc """
  Builds a map representing a grid of sums.
  """
  def grid_of_sums({x_range, y_range}, points) do
    for x <- x_range, y <- y_range, into: %{} do
      distance_sum =
        points
        |> Enum.map(&manhattan_distance(&1, {x, y}))
        |> Enum.sum()

      {{x,y}, distance_sum}
    end
  end
end
