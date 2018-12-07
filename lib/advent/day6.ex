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
    {min, max} = size =
      points
      |> Enum.flat_map(&Tuple.to_list/1)
      |> Enum.min_max()

    grid = labeled_grid(points, size)

    points_with_infinite_areas =
      # Every labeled point that touches an edge of the partial grid...
      for({label, {x, y}} <- grid, x == min or y == min or x == max or y == max, do: label)
      |> Enum.uniq()

    grid
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.reject(&(&1 == "." or &1 in points_with_infinite_areas))
    |> Enum.group_by(& &1)
    |> Enum.map(fn {_, ids} -> Enum.count(ids) end)
    |> Enum.max()
  end

  @doc """
  Build the grid.
  """
  def labeled_grid(points, {min, max}) do
    grid = for x <- min..max, y <- min..max, do: {x, y}
    points = Enum.with_index(points)

    Enum.map(grid, fn {x, y} ->
      {label, _} =
        Enum.reduce(points, {"", :infinity}, fn {p, id}, {label, min} = acc ->
          distance = manhattan_distance(p, {x, y})

          cond do
            label == "." -> acc
            distance > min -> acc
            distance < min -> {id, distance}
            distance == min -> {".", min}
          end
        end)

      {label, {x, y}}
    end)
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
end
