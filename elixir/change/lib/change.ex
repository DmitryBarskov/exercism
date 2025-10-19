defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    case recur(coins, target, %{}) do
      {nil, _} -> {:error, "cannot change"}
      {change, _} when is_list(change) -> {:ok, change}
    end
  end

  defp recur(_, 0, memo), do: {[], memo}
  defp recur(_, target, memo) when target < 0, do: {nil, memo}
  defp recur([], target, memo) when target != 0, do: {nil, memo}

  defp recur([c | rest_coins] = coins, target, memo) do
    key = {coins, target}

    if Map.has_key?(memo, key) do
      {memo[key], memo}
    else
      {skipped, memo} = recur(rest_coins, target, memo)

      case recur(coins, target - c, memo) do
        {change, new_memo} when is_nil(change) or length(change) >= length(skipped) ->
          {skipped, Map.put(new_memo, key, skipped)}

        {change, new_memo} ->
          {[c | change], Map.put(new_memo, key, [c | change])}
      end
    end
  end
end
