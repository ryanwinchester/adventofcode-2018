defmodule Advent.Day3 do
  @moduledoc """
  # Day 3: No Matter How You Slice It

  See: https://adventofcode.com/2018/day/3
  """

  @type claim_id :: pos_integer
  @type coordinate :: {x :: non_neg_integer, y :: non_neg_integer}

  @doc """
  # Part One: Find the total area of overlapping fabric

  My strategy here is to:

    1. build a list of all the points (tuple of coordinate pairs)
    2. group by the point
    3 count all the points that have more than one claim

  ## Example

      iex> Advent.Day3.overlap_area(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"])
      4

  """
  @spec overlap_area([binary]) :: non_neg_integer

  def overlap_area(raw_claims) do
    raw_claims
    |> Enum.map(&parse_claim/1)
    |> Enum.flat_map(&claim_to_points/1)
    |> Enum.group_by(fn {_id, point} -> point end)
    |> Enum.filter(fn {_k, v} -> Enum.count(v) > 1 end)
    |> Enum.count()
  end

  @doc """
  # Part Two: Find the one claim that has no overlap

  My strategy here is to:

    1. build a list of all the points (tuple of coordinate pairs, with ID)
    2. find all the IDs of points that have more than one claim
    3. subtract them from the list of all IDs

  ## Example

      iex> Advent.Day3.intact_claim([
      ...>   "#1 @ 1,3: 4x4",
      ...>   "#2 @ 3,1: 4x4",
      ...>   "#3 @ 5,5: 2x2"
      ...> ])
      3

  """
  @spec intact_claim([binary]) :: claim_id

  def intact_claim(raw_claims) do
    parsed_claims =
      raw_claims
      |> Enum.map(&parse_claim/1)
      |> Enum.flat_map(&claim_to_points/1)
      |> Enum.group_by(fn {_id, point} -> point end)
      |> Map.values()

    claims_with_overlap =
      parsed_claims
      |> Enum.filter(&(Enum.count(&1) > 1))
      |> List.flatten()
      |> Enum.map(fn {id, _point} -> id end)
      |> Enum.uniq()

    claim_ids =
      parsed_claims
      |> List.flatten()
      |> Enum.map(fn {id, _point} -> id end)
      |> Enum.uniq()

    [id] = claim_ids -- claims_with_overlap

    id
  end

  @doc """
  Parses claims to a map.

  ## Example

      iex> Advent.Day3.parse_claim("#123 @ 3,2: 5x4")
      %{
        "id" => 123,
        "x" => 3,
        "y" => 2,
        "w" => 5,
        "h" => 4
      }

  """
  @spec parse_claim(binary) :: [map]

  def parse_claim(claim) do
    Regex.named_captures(~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/, claim)
    |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
    |> Enum.into(%{})
  end

  @doc """
  Converts a parsed claim like:

      %{"id" => 123, "x" => 1, "y" => 1, "w" => 2, "h" => 2}

  into a list of points, which are tuples in the form of `{id, {x, y}}`, like:

      [
        {id, {x1, y1},
        {id, {x2, y2},
        ...
      ]

  ## Example

      iex> claim = %{"id" => 123, "x" => 1, "y" => 1, "w" => 2, "h" => 2}
      iex> Advent.Day3.claim_to_points(claim)
      [
        {123, {1, 1}},
        {123, {1, 2}},
        {123, {2, 1}},
        {123, {2, 2}}
      ]

  """
  @spec claim_to_points(map) :: [{claim_id, coordinate}]

  def claim_to_points(%{"id" => id, "x" => x0, "y" => y0, "w" => w, "h" => h}) do
    for x <- 0..(w - 1), y <- 0..(h - 1) do
      {id, {x0 + x, y0 + y}}
    end
  end
end
