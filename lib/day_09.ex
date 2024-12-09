defmodule AdventOfCode.Y2024.Day09 do
  def motto, do: "Disk Fragmenter"

  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2, 2, [0])
      |> Enum.with_index()

    max = length(input)
    input = input |> Enum.into(%{}, fn {files, idx} -> {idx, files} end)

    {
      p1(input, 0, 0, max - 1, 0),
      0
    }
  end

  defp p1(input, global_index, elem_front, elem_back, sum) when elem_back >= elem_front do
    [file_front, free_front] = Map.get(input, elem_front, [0, 0])
    [file_back, free_back] = Map.get(input, elem_back, [0, 0])

    {sum, input} = cond do
      file_front > 0 -> {elem_front * global_index + sum, Map.put(input, elem_front, [file_front - 1, free_front])}
      free_front > 0 ->
        sum = elem_back * global_index + sum
        input =
          input
          |> Map.put(elem_back, [file_back - 1, free_back])
          |> Map.put(elem_front, [file_front, free_front - 1])
        {sum, input}
    end

    off_front = case Map.get(input, elem_front, [0, 0]) do
      [0, 0] -> 1
      _ -> 0
    end

    off_back = case Map.get(input, elem_back, [0, 0]) do
      [0, _] -> 1
      _ -> 0
    end

    p1(input, global_index + 1, elem_front + off_front, elem_back - off_back, sum)
  end

  defp p1(_input, _global_index, _elem_front, _elem_back, sum) do
    sum
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/09/example.data")
      false -> File.read!("data/09/input.data")
    end
  end
end
