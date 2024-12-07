defmodule AdventOfCode.Y2024.Day02 do
  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split("\n")
      |> Enum.map(fn l -> String.split(l, " ", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.with_index() end)

    p1 =
      input
      |> Enum.map(&check/1)
      |> length()

    {p1, 0}
  end

  defp check(report) do
    {first, _} = Enum.at(report, 0, {-1, -1})
    {second, _} = Enum.at(report, 1, {-1, -1})
    start = first < second

    report
    |> Enum.reduce({true, start}, fn {level, idx}, {continue?, up?} ->
        {next, _} = Enum.at(report, idx + 1, {-1, -1})
        diff = abs(next - level)
        case next do
          -1 -> continue?
          _ -> case {continue?, up?} do
            {true, true} -> {level < next and diff > 0 and diff < 4, true}
            {true, false} -> {level > next and diff > 0 and diff < 4, false}
            {false, _} -> {false, false}
          end
        end
      end)
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/02/example.data")
      false -> File.read!("data/02/input.data")
    end
  end
end
