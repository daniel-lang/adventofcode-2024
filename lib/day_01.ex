defmodule AdventOfCode.Y2024.Day01 do
  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split("\n")
      |> Enum.map(fn l -> String.split(l, "   ", trim: true) |> Enum.map(&String.to_integer/1) end)

    left = input |> Enum.into([], fn [left, _] -> left end) |> Enum.sort(:asc)
    right = input |> Enum.into([], fn [_, right] -> right end) |> Enum.sort(:asc)

    p1 =
      Enum.map(0..length(left)-1, fn index ->
        abs(Enum.at(left, index) - Enum.at(right, index))
      end)
      |> Enum.sum()

    p2 =
      left
      |> Enum.map(fn l ->
        l * Enum.count(right, fn r -> l == r end)
      end)
      |> Enum.sum()

    {p1, p2}
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/01/example.data")
      false -> File.read!("data/01/input.data")
    end
  end
end
