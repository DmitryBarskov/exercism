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
    case recur(coins, target) do
      {:infinity, _} -> {:error, "cannot change"}
      {_, change} -> {:ok, Enum.reverse(change)} # coins are collected in reverse order
    end
  end

  defp recur(
         coins_left, # coins that can used, each coin can be used multiple times
         target, # amount to change
         current_coins \\ 0, # number of coins used already
         acc \\ [], # coins used already
         min_coins \\ :infinity, # minimum number of coins used for a successful change
         min_acc \\ nil # actual coins used for a successful change
       )

  # when collecting more coins, that minimum is, we already don't want to try to change more
  defp recur(_, _, current_coins, _, min_coins, min_acc) when current_coins >= min_coins,
    do: {min_coins, min_acc}

  # changed too much
  defp recur(_, target, _, _, min_coins, min_acc) when target < 0,
    do: {min_coins, min_acc}

  # successful change, since the clause aboved are checked, this is new minimum
  defp recur(_, 0, current_coins, acc, _, _),
    do: {current_coins, acc}

  # no coins left for change
  defp recur([], _, _, _, min_coins, min_acc),
    do: {min_coins, min_acc}

  # first check when we use the largest available coin
  # second check when we skip the largest available coin
  defp recur([c | coins_left] = coins, target, current_coins, acc, min_coins, min_acc) do
    {min_coins, min_acc} =
      recur(coins, target - c, current_coins + 1, [c | acc], min_coins, min_acc)

    recur(coins_left, target, current_coins, acc, min_coins, min_acc)
  end
end
