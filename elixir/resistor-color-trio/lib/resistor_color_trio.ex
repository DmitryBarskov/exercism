defmodule ResistorColorTrio do
  @atom_to_number %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    [tens, ones, power | _] = colors |> Enum.map(&@atom_to_number[&1])
    shorten_ohms((tens * 10 + ones) * 10 ** power)
  end

  defp shorten_ohms(ohms) do
    [gigaohms: 1_000_000_000, megaohms: 1_000_000, kiloohms: 1_000, ohms: 1]
    |> Enum.find(fn {_unit, power} -> rem(ohms, power) == 0 and ohms >= power end)
    |> then(fn
      nil -> {0, :ohms}
      {unit, power} -> {div(ohms, power), unit}
    end)
  end
end
