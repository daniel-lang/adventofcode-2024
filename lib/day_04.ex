defmodule AdventOfCode.Y2024.Day04 do
  def run(sample \\ true) do
    input = get_input(sample)
    |> String.split()
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), &parse_row/2)

    {run_part1(input), run_part2(input)}
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/04/example.data")
      false -> File.read!("data/04/input.data")
    end
  end

  defp run_part1(input) do
    input
    |> find_char("X")
    |> Enum.flat_map(&find_xmas(input, &1))
    |> length()
  end

  defp run_part2(input) do
    input
    |> find_char("A")
    |> Enum.flat_map(&find_mas(input, &1))
    |> length()
  end

  defp find_xmas(grid, coords) do
    # 8 directions that the word can go
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {-1, -1}, {1, -1}, {-1, 1}]
    |> Enum.filter(fn dir ->
      matches?(grid, coords, dir, 1, "M") &&
      matches?(grid, coords, dir, 2, "A") &&
      matches?(grid, coords, dir, 3, "S")
    end)
  end

  defp find_mas(grid, coords) do
    [
      [[{1, -1}, {1, 1}], [{-1, 1}, {-1, -1}]],
      [[{-1, -1}, {1, -1}], [{-1, 1}, {1, 1}]]
    
    ]
    |> Enum.filter(fn [side1, side2] ->
      Enum.all?(side1, &matches?(grid, coords, &1, 1, "M")) &&
      Enum.all?(side2, &matches?(grid, coords, &1, 1, "S")) ||
      Enum.all?(side1, &matches?(grid, coords, &1, 1, "S")) &&
      Enum.all?(side2, &matches?(grid, coords, &1, 1, "M"))
    end)
  end

  defp find_char(grid, search) do
    grid
    |> Enum.filter(fn {_xy, char} -> char == search end)
    |> Enum.map(fn {xy, _char} -> xy end)
  end

  defp matches?(grid, {y1, x1}, {y2, x2}, offset, char) do
    Map.get(grid, {y1 + offset * y2, x1 + offset * x2}) == char
  end

  defp parse_row({row, y}, map) do
    row
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(map, fn {col, x}, map -> 
      Map.put(map, {y + 1, x + 1}, col)
    end)
  end
end
