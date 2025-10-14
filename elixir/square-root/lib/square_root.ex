defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    binary_search(
      0,
      radicand,
      fn candidate -> candidate * candidate >= radicand end
    )
  end

  # find first integer matching predicate
  defp binary_search(lower, higher, _) when lower >= higher, do: lower

  defp binary_search(lower, higher, predicate) do
    middle = trunc((lower + higher) / 2)

    if predicate.(middle) do
      binary_search(lower, middle, predicate)
    else
      binary_search(middle + 1, higher, predicate)
    end
  end
end
