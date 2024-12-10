defmodule AdventOfCode.Y2024.Day10 do
  def motto, do: "Hoof It"

  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split("\n")

    height = length(input)
    width = String.length(hd(input))

    input =
      input
      |> Enum.map(fn row -> String.split(row, "", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.with_index() end)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, row_idx} ->
          Enum.map(row, fn {col, col_idx} -> {row_idx, col_idx, col} end)
        end)
      |> Enum.into(Map.new(), fn {row, col, value} -> {{row, col}, value} end)

    trails =
      input
      |> Enum.filter(fn {{_, _}, value} -> value == 0 end)
      |> Enum.map(fn {{row, col}, value} -> step(input, width, height, row, col, value, -1) end)

    p1 = trails |> Enum.reduce(0, fn trail, acc -> acc + (Enum.uniq(trail) |> length()) end)
    p2 = trails |> Enum.reduce(0, fn trail, acc -> acc + length(trail) end)

    {p1, p2}
  end

  defp step(grid, width, height, row, col, value, prev_value) when row >= 0 and row < height and col >= 0 and col < width do
    cond do
      prev_value + 1 != value -> []
      value == 9 -> ["#{row},#{col}"]
      true ->
        step(grid, width, height, row + 1, col, Map.get(grid, {row + 1, col}, -1), value) ++
        step(grid, width, height, row - 1, col, Map.get(grid, {row - 1, col}, -1), value) ++
        step(grid, width, height, row, col + 1, Map.get(grid, {row, col + 1}, -1), value) ++
        step(grid, width, height, row, col - 1, Map.get(grid, {row, col - 1}, -1), value)
    end
  end

  defp step(_, _, _, _, _, _, _) do
    []
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/10/example.data")
      false -> File.read!("data/10/input.data")
    end
  end

  {0, 0}
end
