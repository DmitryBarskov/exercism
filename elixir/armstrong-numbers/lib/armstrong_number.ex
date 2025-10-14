defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    {digits, number_of_digits} = integer_to_digits(number)

    Enum.reduce(
      digits,
      0,
      fn digit, sum -> digit ** number_of_digits + sum end
    ) == number
  end

  defp integer_to_digits(number, digits \\ [], number_of_digits \\ 0)
  defp integer_to_digits(0, digits, number_of_digits), do: {digits, number_of_digits}

  defp integer_to_digits(number, digits, number_of_digits) do
    integer_to_digits(
      div(number, 10),
      [rem(number, 10) | digits],
      1 + number_of_digits
    )
  end
end
