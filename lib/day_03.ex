defmodule AdventOfCode.Y2024.Day03 do
  def run(sample \\ true) do
    input = get_input(sample)
    {run_part1(input), run_part2(input)}
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/03/example.data")
      false -> File.read!("data/03/input.data")
    end
  end

  defp run_part1(input) do
    regex = ~r/mul\((\d+),(\d+)\)/
    Regex.scan(regex, input, capture: :all_but_first)
    |> Enum.map(fn m -> Enum.map(m, fn i -> String.to_integer(i) end) end)
    |> Enum.map(fn n -> Enum.reduce(n, &*/2) end)
    |> Enum.sum()
  end

  defp run_part2(input) do
    regex = ~r/(mul|do|don't)\((\d+,\d+)?\)/
    Regex.scan(regex, input, capture: :all_but_first)
    |> Enum.reduce({true, 0}, fn [instruction | nums], {continue?, total} ->
      case {continue?, instruction} do
        {_, "do"} -> {true, total}
        {_, "don't"} -> {false, total}
        {true, _} -> {true, multiply(hd(nums)) + total}
        {false, _} -> {false, total}
      end
    end)
    |> elem(1)
  end

  def multiply(number) do
    String.split(number, ",")
    |> Enum.map(fn i -> String.to_integer(i) end)
    |> Enum.reduce(&*/2)
  end
end
