defmodule AdventOfCode do
  @type year() :: 2024
  @type day() :: pos_integer()

  def start(_type, _args) do
    IO.puts("Day 01 - Historian Hysteria")
    solve(2024, 1, false)
    IO.puts("\nDay 02 - Red-Nosed Reports")
    solve(2024, 2, false)
    IO.puts("\nDay 03 - Mull It Over")
    solve(2024, 3, false)
    IO.puts("\nDay 04 - Ceres Search")
    solve(2024, 4, false)
    IO.puts("\nDay 05 - Print Queue")
    solve(2024, 5, false)
    IO.puts("\nDay 06 - Guard Gallivant")
    solve(2024, 6, false)
    IO.puts("\nDay 07 - Bridge Repair")
    solve(2024, 7, false)
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
