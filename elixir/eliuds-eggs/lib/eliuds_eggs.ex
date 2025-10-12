defmodule EliudsEggs do
  import Bitwise, only: [band: 2, bsr: 2]

  @doc """
  Given the number, count the number of eggs.
  """

  @spec egg_count(number :: integer()) :: non_neg_integer()
  def egg_count(0), do: 0
  def egg_count(number), do: band(number, 1) + egg_count(bsr(number, 1))
end
