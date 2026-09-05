defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(pos_integer()) :: pos_integer()
  def nth(count) when count <= 0, do: raise RuntimeError, "only positive index"
  def nth(count) do
    infinite_range = Stream.unfold(1, fn n -> {n, n + 1} end)
    Enum.reduce_while(infinite_range, {0, 1}, fn
      _, {^count, last_prime} -> {:halt, last_prime}
      candidate, {i, last_prime} -> if prime?(candidate) do
        {:cont, {i + 1, candidate}}
      else
        {:cont, {i, last_prime}}
      end
    end)
  end

  @spec prime?(pos_integer()) :: boolean
  def prime?(1), do: false
  def prime?(2), do: true
  def prime?(num) do
    2..ceil(:math.sqrt(num))
    |> Enum.all?(fn divisor -> rem(num, divisor) != 0 end)
  end
end
