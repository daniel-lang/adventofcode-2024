defmodule AdventOfCode.Y2024.Day07 do
  def motto, do: "Bridge Repair"

  def run(sample \\ true) do
    input =
      get_input(sample)
      |> String.split("\n")
      |> Enum.map(fn l -> String.split(l, ":", trim: true) end)
      |> Enum.into([], fn [result, calc] ->
          {
            String.to_integer(result),
            String.split(calc, " ", trim: true) |> Enum.map(&String.to_integer/1)
          }
        end)

    p1 =
      input
      |> Enum.map(fn {result, calc} ->
        start = Enum.at(calc, 0)

        case calculate(result, calc, 1, start, 0, 1) or calculate(result, calc, 1, start, 1, 1) do
          true -> result
          false -> 0
        end
      end)
      |> Enum.sum()

    p2 =
      input
      |> Enum.map(fn {result, calc} ->
        start = Enum.at(calc, 0)

        case calculate(result, calc, 1, start, 0, 2) or calculate(result, calc, 1, start, 1, 2) or calculate(result, calc, 1, start, 2, 2) do
          true -> result
          false -> 0
        end
      end)
      |> Enum.sum()


      {p1, p2}
  end

  defp calculate(result, calc, index, curr_result, operator, max_op) when index < length(calc) do
    num = Enum.at(calc, index)
    curr_result = case operator do
      0 -> curr_result * num
      1 -> curr_result + num
      2 -> Enum.join([curr_result, num], "") |> String.to_integer()
    end

    case max_op do
      1 -> calculate(result, calc, index + 1, curr_result, 0, max_op) or calculate(result, calc, index + 1, curr_result, 1, max_op)
      2 -> calculate(result, calc, index + 1, curr_result, 0, max_op) or calculate(result, calc, index + 1, curr_result, 1, max_op) or calculate(result, calc, index + 1, curr_result, 2, max_op)
    end
  end

  defp calculate(result, _calc, _index, curr_result, _operator, _max_op) do
    result == curr_result
  end

  defp get_input(sample) do
    case sample do
      true -> File.read!("data/07/example.data")
      false -> File.read!("data/07/input.data")
    end
  end
end
