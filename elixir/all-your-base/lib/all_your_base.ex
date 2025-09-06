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
    with number when is_integer(number) <- undigits(digits, input_base),
         output when is_list(output) <- digits(number, output_base),
         do: {:ok, output}
  end

  defp undigits(_, base) when base < 2, do: {:error, "input base must be >= 2"}

  defp undigits(digits, base) do
    Enum.reduce_while(
      digits,
      0,
      fn
        digit, _ when digit >= base or digit < 0 ->
          {:halt, {:error, "all digits must be >= 0 and < input base"}}

        digit, acc ->
          {:cont, acc * base + digit}
      end
    )
  end

  defp digits(_, base) when base < 2, do: {:error, "output base must be >= 2"}
  defp digits(0, _), do: [0]

  defp digits(number, base) do
    Enum.reduce_while(
      Stream.iterate(0, &(&1 + 1)),
      {number, []},
      fn
        _, {0, digits} -> {:halt, digits}
        _, {num, digits} -> {:cont, {div(num, base), [rem(num, base) | digits]}}
      end
    )
  end
end
