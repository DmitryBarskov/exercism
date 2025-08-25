defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({num1, den1}, {num2, den2}) do
    {num1 * den2 + num2 * den1, den1 * den2} |> reduce
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, {num2, den2}) do
    add(a, {-num2, den2})
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({num1, den1}, {num2, den2}) do
    {num1 * num2, den1 * den2} |> reduce
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(divisible :: rational, divisor :: rational) :: rational
  def divide_by(divisible, {num2, den2}) do
    multiply(divisible, {den2, num2})
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({numerator, denominator}) do
    {Kernel.abs(numerator), Kernel.abs(denominator)} |> reduce
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({num, den}, n) when n < 0, do: pow_rational({den, num} |> reduce_sign, -n)
  def pow_rational({num, den}, n) do
    {Integer.pow(num, n), Integer.pow(den, n)}
  end

  @doc """
  Exponentiation of a real number by a rational number
  Exponentiation of a real number `x` to a rational number `r = a/b` is `x^(a/b) = root(x^a, b)`, where `root(p, q)` is the `q`th root of `p`.
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {numerator, denominator}) do
    Float.pow(x * 1.0, numerator / denominator)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({numerator, denominator}) do
    gcd = Integer.gcd(numerator, denominator)
    {numerator / gcd, denominator / gcd} |> reduce_sign
  end

  defp reduce_sign({num, den}) when den < 0, do: {-num, -den}
  defp reduce_sign(a), do: a
end
