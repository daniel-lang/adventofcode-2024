defmodule AdventOfCode.Y2024.Day06 do
  def motto, do: "Guard Gallivant"

  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split("\n")

    height = length(input)
    width = String.length(hd(input))

    obstacles =
      input
      |> Stream.map(fn row -> String.split(row, "", trim: true) |> Enum.with_index() end)
      |> Stream.with_index()
      |> Stream.flat_map(fn {row, row_idx} ->
        Enum.map(row, fn {col, col_idx} -> {row_idx, col_idx, col} end)
      end)
      |> Enum.filter(fn {_row, _col, char} -> char != "." end)

    [{start_row, start_col, _}] =
      obstacles
      |> Enum.filter(fn {_row, _col, char} -> char == "^" end)

    obstacles =
      obstacles
      |> List.delete({start_row, start_col, "^"})
      |> Enum.map(fn {row, col, _} -> {row, col} end)

    visited =
      move({start_row, start_col}, {-1, 0}, obstacles, width, height, [])
      |> Enum.uniq_by(fn {row, col} -> "#{row}-#{col}" end)

    p1 = length(visited)

    :persistent_term.put(Y2024Day06, {{start_row, start_col}, obstacles, width, height})

    p2 = 0

    {p1, p2}
  end

  defp move({row, col}, dir, obstacles, width, height, visited) when row >= 0 and row < height and col >= 0 and col < width do
    visited = [{row, col} | visited]

    {row_dir, col_dir} = dir
    {row_next, col_next} = {row + row_dir, col + col_dir}

    case obstacles |> Enum.find(nil, fn {row_ob, col_ob} -> row_ob == row_next and col_ob == col_next end) do
      nil -> move({row_next, col_next}, dir, obstacles, width, height, visited)
      _ -> move({row, col}, {col_dir, -row_dir}, obstacles, width, height, visited)
    end
  end

  defp move(_pos, _dir, _obstacles, _width, _height, visited) do
    visited
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/06/example.data")
      false -> File.read!("data/06/input.data")
    end
  end
end
