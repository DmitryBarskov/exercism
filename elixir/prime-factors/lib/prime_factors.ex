defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: factors_for(number, 2, [])

  defp factors_for(1, _divisor, acc), do: Enum.reverse(acc)

  defp factors_for(number, divisor, acc) when divisor * divisor > number,
    do: factors_for(1, divisor + 1, [number | acc])

  defp factors_for(number, divisor, acc) do
    if Integer.mod(number, divisor) == 0 do
      factors_for(div(number, divisor), divisor, [divisor | acc])
    else
      factors_for(number, divisor + 1, acc)
    end
  end
end
