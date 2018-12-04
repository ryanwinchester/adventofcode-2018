defmodule Advent.Day3 do
  @moduledoc """
  --- Day 3: No Matter How You Slice It ---

  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's
  suit (thanks to someone who helpfully wrote its box IDs on the wall of the
  warehouse in the middle of the night). Unfortunately, anomalies are still
  affecting them - nobody can even agree on how to cut the fabric.

  The whole piece of fabric they're working on is a very large square - at least
  1000 inches on each side.

  Each Elf has made a claim about which area of fabric would be ideal for
  Santa's suit. All claims have an ID and consist of a single rectangle with
  edges parallel to the edges of the fabric. Each claim's rectangle is defined
  as follows:

    - The number of inches between the left edge of the fabric and the left edge
      of the rectangle.
    - The number of inches between the top edge of the fabric and the top edge
      of the rectangle.
    - The width of the rectangle in inches.
    - The height of the rectangle in inches.

  A claim like `#123 @ 3,2: 5x4` means that claim ID `123` specifies a rectangle
  `3` inches from the left edge, `2` inches from the top edge, `5` inches wide,
  and `4` inches tall. Visually, it claims the square inches of fabric
  represented by `#` (and ignores the square inches of fabric represented
  by `.`) in the diagram below:

      ...........
      ...........
      ...#####...
      ...#####...
      ...#####...
      ...#####...
      ...........
      ...........
      ...........

  The problem is that many of the claims overlap, causing two or more claims to
  cover part of the same areas. For example, consider the following claims:

      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2

  Visually, these claim the following areas:

      ........
      ...2222.
      ...2222.
      .11XX22.
      .11XX22.
      .111133.
      .111133.
      ........

  The four square inches marked with `X` are claimed by both `1` and `2`.
  (Claim `3`, while adjacent to the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough
  fabric. How many square inches of fabric are within two or more claims?

  --- Part Two ---

  Amidst the chaos, you notice that exactly one claim doesn't overlap by even a
  single square inch of fabric with any other claim. If you can somehow draw
  attention to it, maybe the Elves will be able to make Santa's suit after all!

  For example, in the claims above, only claim 3 is intact after all claims are
  made.

  What is the ID of the only claim that doesn't overlap?

  """

  def overlap_area(raw_claims) do
    raw_claims
    |> parse_claims()
    |> Enum.map(&claim_to_points/1)
    |> List.flatten()
    |> Enum.group_by(fn {_id, point} -> point end)
    |> Enum.filter(fn {_k, v} -> Enum.count(v) > 1 end)
    |> Enum.count()
  end

  def intact_claim(raw_claims) do
    parsed_claims =
      raw_claims
      |> parse_claims()
      |> Enum.map(&claim_to_points/1)
      |> List.flatten()
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

    [id] = (claim_ids -- claims_with_overlap)

    id
  end

  # Parses claims like:
  #
  #     "#123 @ 3,2: 5x4"
  #
  # into something like:
  #
  #     %{"id" => 123, "x" => 3, "y" => 2, "w" => 5, "h" => 4}
  #
  defp parse_claims(claims) do
    Enum.map(claims, fn claim ->
      Regex.named_captures(~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/, claim)
      |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
      |> Enum.into(%{})
    end)
  end

  # Converts a parsed claim like:
  #
  #     %{"id" => 123, "x" => 1, "y" => 1, "w" => 2, "h" => 2}
  #
  # into a list of points, which are tuples in the form of `{id, {x, y}}`, like:
  #
  #     [{123, {1, 1}, {123, {1, 2}, {123, {2, 1}, {123, {2, 2}]
  #
  defp claim_to_points(claim) do
    for x <- 0..(claim["w"] - 1), y <- 0..(claim["h"] - 1) do
      {claim["id"], {claim["x"] + x, claim["y"] + y}}
    end
  end
end
