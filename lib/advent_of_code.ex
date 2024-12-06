defmodule AdventOfCode do
  @type year() :: 2024
  @type day() :: pos_integer()

  def start(_type, _args) do
    solve(2024, 6, false)
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
