defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    result = binary_search(0, tuple_size(numbers), fn i -> elem(numbers, i) >= key end)

    if result < tuple_size(numbers) and elem(numbers, result) == key do
      {:ok, result}
    else
      :not_found
    end
  end

  # predicate must be monotonous on lo..hi range, i.e.
  #           i  lo, lo + 1, lo + 2, ..., hi - 2, hi - 1, hi
  # predicate(i)  f,      f,      f,   t,      t,      t,  t
  defp binary_search(lo, hi, _) when lo >= hi, do: lo

  defp binary_search(lo, hi, predicate) do
    mi = div(lo + hi, 2)

    if predicate.(mi) do
      binary_search(lo, mi, predicate)
    else
      binary_search(mi + 1, hi, predicate)
    end
  end
end
