defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(pos_integer()) :: pos_integer()
  def nth(count) when count <= 0, do: raise(RuntimeError, "only positive index")
  def nth(count), do: nth(count, 1, 1)

  @spec nth(pos_integer(), pos_integer(), pos_integer()) :: pos_integer()
  defp nth(0, _, last_prime), do: last_prime
  defp nth(count, candidate, last_prime) do
    if prime?(candidate) do
      nth(count - 1, candidate + 1, candidate)
    else
      nth(count, candidate + 1, last_prime)
    end
  end

  @spec prime?(pos_integer()) :: boolean
  def prime?(1), do: false
  def prime?(2), do: true
  def prime?(num) do
    2..ceil(:math.sqrt(num))
    |> Enum.all?(fn divisor -> rem(num, divisor) != 0 end)
  end
end
