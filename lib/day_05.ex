defmodule AdventOfCode.Y2024.Day05 do
  def run(sample \\ true) do
    [rules, updates] = get_input(sample)
    |> String.split("\n\n")

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn l -> l |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    Enum.reduce(updates, {0, 0}, fn update, {part1, part2} ->
      modified_update = Enum.sort_by(update, &Function.identity/1, fn left, right ->
        String.contains?(rules, "#{left}|#{right}")
      end)

      index = floor(length(update) / 2)
      middle = Enum.at(modified_update, index)

      case update == modified_update do
        true -> {part1 + middle, part2}
        false -> {part1, part2 + middle}
      end
    end)
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/05/example.data")
      false -> File.read!("data/05/input.data")
    end
  end
end
