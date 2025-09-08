defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun), do: keep_iter(list, fun, [])

  defp keep_iter([], _, acc), do: Enum.reverse(acc)

  defp keep_iter([item | rest], predicate, acc) do
    if predicate.(item) do
      keep_iter(rest, predicate, [item | acc])
    else
      keep_iter(rest, predicate, acc)
    end
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun), do: keep(list, fn item -> !fun.(item) end)
end
