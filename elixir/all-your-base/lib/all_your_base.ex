defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  AllYourBase.convert([0, 6, 0], 7, 10) == {:ok, [4, 2]}
  AllYourBase.convert([1, 0, 1, 0, 1, 0], 2, 10) == {:ok, [4, 2]}
  # Which means convert 0b101010 to 42
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) do
    with {:ok, number} <- digits_to_integer(digits, input_base),
         {:ok, output} <- integer_to_digits(number, output_base),
         do: {:ok, output}
  end

  # builds an integer from given digits and base
  defp digits_to_integer(_, base, acc \\ 0)

  defp digits_to_integer(_, base, _) when base < 2 do
    {:error, "input base must be >= 2"}
  end

  defp digits_to_integer([d | _], base, _) when d < 0 or d >= base do
    {:error, "all digits must be >= 0 and < input base"}
  end

  defp digits_to_integer([], _, acc), do: {:ok, acc}

  defp digits_to_integer([d | rest], base, acc) do
    digits_to_integer(rest, base, acc * base + d)
  end

  # returns digits of an integer in the given base
  defp integer_to_digits(num, base, digits \\ [])

  defp integer_to_digits(_, base, _) when base < 2 do
    {:error, "output base must be >= 2"}
  end

  defp integer_to_digits(0, _, []), do: {:ok, [0]}
  defp integer_to_digits(0, _, digits), do: {:ok, digits}

  defp integer_to_digits(num, base, digits) do
    integer_to_digits(div(num, base), base, [rem(num, base) | digits])
  end
end
