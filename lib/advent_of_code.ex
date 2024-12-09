defmodule AdventOfCode do
  @type year() :: 2024
  @type day() :: pos_integer()

  def start(_type, _args) do
    header = ["Day", "Motto", "Time [ms]", "Part 1", "Part 2"]

    rows = Enum.into([1,2,3,4,5,6,7,9], [], fn day ->
      day_string =
        day
        |> Integer.to_string()
        |> String.pad_leading(2, "0")

      module = Module.concat([AdventOfCode, get_year_module(2024), get_day_module(day)])

      {time, {p1, p2}} = :timer.tc(&module.run/1, [false], :millisecond)

      [day_string, module.motto(), time, p1, p2]
    end)

    TableRex.quick_render!(rows, header)
    |> IO.puts()

    {:ok, self()}
  end

  def solve(year, day, sample) do
    {first, second} = Module.concat([AdventOfCode, get_year_module(year), get_day_module(day)]).run(sample)
    IO.inspect(first)
    IO.inspect(second)
    :ok
  end

  defp get_year_module(year) when year == 2024 do
    "Y" <> Integer.to_string(year)
  end

  defp get_day_module(day) when day >= 1 and day <= 25 do
    day
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
    |> then(fn day -> "Day" <> day end)
  end
end
