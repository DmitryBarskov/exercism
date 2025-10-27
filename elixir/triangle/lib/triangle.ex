defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when a < b, do: kind(b, a, c)
  # a >= b here and below

  def kind(a, b, c) when a < c, do: kind(c, a, b)
  # a >= b and a >= c here and below

  def kind(a, b, c) when b < c, do: kind(a, c, b)
  # a >= b >= c here and below

  def kind(_, _, c) when c <= 0 do
    {:error, "all side lengths must be positive"}
  end

  def kind(a, b, c) when a > b + c do
    {:error, "side lengths violate triangle inequality"}
  end

  def kind(a, a, a), do: {:ok, :equilateral}
  def kind(a, a, _), do: {:ok, :isosceles}
  def kind(_, a, a), do: {:ok, :isosceles}
  def kind(_, _, _), do: {:ok, :scalene}
end
