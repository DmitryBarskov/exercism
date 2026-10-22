defmodule Spiral do
  import Integer

  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(dimension) do
    Enum.map(1..dimension//1, fn row ->
      Enum.map(1..dimension//1, fn col ->
        cell(dimension, row, col)
      end)
    end)
  end

  @spec cell(dimension :: integer, row :: integer, col :: integer) :: integer
  defp cell(dimension, row, col) do
    layers = ceil(dimension / 2)

    # "layer" is distance to the closest edge: 1 for outermost rows/columns
    layer = Enum.min([row, col, dimension - row + 1, dimension - col + 1])

    inner_area =
      if is_even(dimension) do
        (dimension - 2 * layer) ** 2
      else
        # (layers - layer) => inner area
        # 0 => 0
        # 1 => 1
        # 2 => 9
        # 3 => 25
        # 4 => 49...
        (2 * (layers - layer) - 1) ** 2
      end

    # given layer perimeter
    perimeter = (dimension - 2 * layer + 1) * 4

    # top left number of the layer
    first_num_in_layer = dimension ** 2 - perimeter - inner_area + 1

    # "top_right?" is whether the cell is on or above the main diagonal or not
    top_right? = col >= row

    # "offset" is how many steps are there from top left corner of given layer
    offset =
      if top_right? do
        row + col - 2 * layer
      else
        4 * dimension - 6 * layer - row - col + 4
      end

    first_num_in_layer + offset
  end
end
