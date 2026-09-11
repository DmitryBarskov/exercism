defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {number, number}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: number
  def real({real_part, _imaginary}), do: real_part

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: number
  def imaginary({_real, imaginary_part}), do: imaginary_part

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | number, b :: complex | number) :: complex
  def mul(a, b) when is_number(a), do: mul({a, 0}, b)
  def mul(a, b) when is_number(b), do: mul(a, {b, 0})
  def mul({a_r, a_im}, {b_r, b_im}) do
    {a_r * b_r - a_im * b_im, a_r * b_im + b_r * a_im}
  end

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | number, b :: complex | number) :: complex
  def add(a, b) when is_number(a), do: add({a, 0}, b)
  def add(a, b) when is_number(b), do: add(a, {b, 0})
  def add({a_r, a_im}, {b_r, b_im}), do: {a_r + b_r, a_im + b_im}

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | number, b :: complex | number) :: complex
  def sub(a, b) when is_number(a), do: sub({a, 0}, b)
  def sub(a, b) when is_number(b), do: sub(a, {b, 0})
  def sub({a_r, a_im}, {b_r, b_im}), do: {a_r - b_r, a_im - b_im}

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | number, b :: complex | number) :: complex
  def div(a, b) when is_number(a), do: ComplexNumbers.div({a, 0}, b)
  def div(a, b) when is_number(b), do: ComplexNumbers.div(a, {b, 0})
  def div({a_r, a_im}, {b_r, b_im}) do
    b_abs_sqr = b_r * b_r + b_im * b_im

    {
      (a_r * b_r + a_im * b_im) / b_abs_sqr,
      (a_im * b_r - a_r * b_im) / b_abs_sqr
    }
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: number
  def abs({r, im}), do: :math.sqrt(r * r + im * im)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({r, im}), do: {r, -im}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({r, im}) do
    {:math.exp(r) * :math.cos(im), :math.exp(r) * :math.sin(im)}
  end
end
