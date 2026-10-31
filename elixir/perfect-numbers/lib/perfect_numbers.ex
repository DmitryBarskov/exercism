defmodule PerfectNumbers do
  import Integer

  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number <= 0,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(number) do
    sum = aliquot_sum(number)

    cond do
      sum < number -> {:ok, :deficient}
      sum > number -> {:ok, :abundant}
      sum == number -> {:ok, :perfect}
    end
  end

  # The sum of the factors of a number not including the number itself.
  # The aliquot sum of a prime number is 1.
  defp aliquot_sum(1), do: 0

  defp aliquot_sum(number) do
    2..trunc(:math.sqrt(number))//1
    |> Enum.reduce(1, fn candidate, acc ->
      cond do
        mod(number, candidate) == 0 and candidate * candidate != number ->
          acc + candidate + trunc(number / candidate)

        mod(number, candidate) == 0 ->
          acc + candidate

        true ->
          acc
      end
    end)
  end
end
