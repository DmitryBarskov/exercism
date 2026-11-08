defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: count(l, 0)

  defp count([], acc), do: acc
  defp count([_ | rest], acc), do: count(rest, acc + 1)

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])

  defp reverse([], reversed), do: reversed
  defp reverse([item | rest], acc), do: reverse(rest, [item | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: map(l, f, [])

  defp map([], _f, acc), do: reverse(acc)
  defp map([item | rest], f, acc), do: map(rest, f, [f.(item) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter(l, f, [])

  defp filter([], _f, acc), do: reverse(acc)

  defp filter([item | rest], f, acc) do
    if f.(item) do
      filter(rest, f, [item | acc])
    else
      filter(rest, f, acc)
    end
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _f), do: acc
  def foldl([x | rest], acc, f), do: foldl(rest, f.(x, acc), f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _f), do: acc
  def foldr([item | rest], acc, f), do: f.(item, foldr(rest, acc, f))

  @spec append(list, list) :: list
  def append([], b), do: b
  def append([item | rest], b), do: [item | append(rest, b)]

  @spec concat([[any]]) :: [any]
  def concat(ll), do: foldr(ll, [], &append/2)
end
