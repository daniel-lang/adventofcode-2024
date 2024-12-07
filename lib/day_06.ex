defmodule AdventOfCode.Y2024.Day06 do
  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split()

    height = length(input)
    width = String.length(hd(input))

    input =
      input
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), &parse_row/2)

    directionChars = [
      [0, "^"],
      [1, ">"],
      [2, "v"],
      [3, "<"]
    ]

    directions = [
      {-1, 0},
      {0, 1},
      {1, 0},
      {0, -1}
    ]

    start =
      directionChars
      |> Enum.flat_map(fn dir ->
        [idx, char] = dir
        pos = find_char(input, char)
        case pos do
          [] -> []
          _ -> pos ++ [idx]
        end
      end)

    [pos, dir] = start

    input = Map.replace(input, pos, ".")

    p1 =
      move(pos, dir, input, width, height, directions, [])
      |> Enum.uniq_by(fn {row, col} -> "#{row}-#{col}" end)
      |> length()

    positions = Enum.flat_map(0..height, fn row ->
      Enum.map(0..width, fn col -> {row, col} end)
    end)

    p2 =
        Task.async_stream(positions, &loops?(pos, dir, input, width, height, directions, &1))
      |> Enum.reduce(0, fn {:ok, num}, acc -> num + acc end)

    {p1, p2}
  end

  defp loops?(start, dir, grid, width, height, directions, {rowObst, colObst}) do
    case start == {rowObst, colObst} and Map.get(grid, {rowObst, colObst}, ".") != "#" do
      true -> 0
      false ->
        modified_grid = Map.replace(grid, {rowObst, colObst}, "#")
        move_p2(start, dir, modified_grid, width, height, directions, [])
    end
  end

  defp move_p2({row, col}, dir, grid, width, height, directions, visited) when row >= 0 and row < height and col >= 0 and col < width do
    case Enum.member?(visited, {row, col, dir}) do
      true -> 1
      false ->
        visited = [ {row, col, dir} | visited ]
        {next_pos, next_dir} = get_next(grid, row, col, dir, directions)
        move_p2(next_pos, next_dir, grid, width, height, directions, visited)
    end
  end

  defp move_p2(_pos, _dir, _grid, _width, _height, _directions, _visited) do
    0
  end

  defp move({row, col}, dir, grid, width, height, directions, visited) when row >= 0 and row < height and col >= 0 and col < width do
    visited = [ {row, col} | visited ]

    {next_pos, next_dir} = get_next(grid, row, col, dir, directions)
    move(next_pos, next_dir, grid, width, height, directions, visited)
  end

  defp move(_pos, _dir, _grid, _width, _height, _directions, visited) do
    visited
  end

  defp get_next(grid, row, col, dir, directions) do
    {row_offset, col_offset} = Enum.at(directions, dir)
    pos = {row + row_offset, col + col_offset}

    char = Map.get(grid, pos, ".")
    if char == "." do
      {pos, dir}
    else
      if dir + 1 == length(directions) do
        get_next(grid, row, col, 0, directions)
      else
        get_next(grid, row, col, dir + 1, directions)
      end
    end
  end

  defp find_char(grid, search) do
    grid
    |> Enum.filter(fn {_, char} -> char == search end)
    |> Enum.map(fn {pos, _} -> pos end)
  end

  defp parse_row({row, y}, map) do
    row
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(map, fn {col, x}, map ->
      Map.put(map, {y, x}, col)
    end)
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/06/example.data")
      false -> File.read!("data/06/input.data")
    end
  end
end
