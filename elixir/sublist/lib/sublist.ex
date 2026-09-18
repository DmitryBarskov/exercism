defmodule Sublist do
  @type answer :: :equal | :sublist | :superlist | :unequal

  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  @spec compare(list(), list()) :: answer()
  def compare(a, b) do
    a_includes_b? = includes?(a, b)
    b_includes_a? = includes?(b, a)

    cond do
      a_includes_b? and b_includes_a? -> :equal
      a_includes_b? -> :superlist
      b_includes_a? -> :sublist
      true -> :unequal
    end
  end

  defp includes?([], []), do: true
  defp includes?([], _), do: false

  defp includes?([a | as], bs) do
    start_with?([a | as], bs) or includes?(as, bs)
  end

  defp start_with?(_, []), do: true
  defp start_with?([], _), do: false
  defp start_with?([a | as], [a | bs]), do: start_with?(as, bs)
  defp start_with?(_, _), do: false
end
