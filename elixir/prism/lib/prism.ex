defmodule Prism do
  @doc """
  Finds the sequence of prisms that the laser will hit.
  """

  @type start :: %{angle: number(), x: number(), y: number()}
  @type prism :: %{id: integer(), angle: number(), x: number(), y: number()}

  @spec find_sequence(prisms :: [prism()], start :: start()) :: [integer()]
  def find_sequence(prisms, start) do
    bounds = %{
      x: [start | prisms] |> Enum.map(& &1.x) |> Enum.min_max(),
      y: [start | prisms] |> Enum.map(& &1.y) |> Enum.min_max()
    }

    find_sequence_iter(bounds, prisms, start, [])
  end

  # precision should be slightly smaller than step
  @step 0.02
  @precision 0.015

  # angle precision only allows using Integer.mod/2 on angles # in Prism.step/3.
  # It should have as many zeroes as the number of digits an angle's
  # fractional part may have.
  @angle_precision 1000

  defp find_sequence_iter(
         %{x: {min_x, max_x}, y: {min_y, max_y}},
         _prisms,
         %{angle: _, x: x, y: y},
         acc
       )
       when x < min_x - @precision or max_x + @precision < x or
              y < min_y - @precision or max_y + @precision < y do
    Enum.reverse(acc)
  end

  defp find_sequence_iter(bounds, prisms, %{angle: angle, x: x, y: y} = pos, acc) do
    prism_hit = Enum.find(prisms, fn prism -> dist(prism, pos) < @precision end)

    cond do
      prism_hit ->
        new_angle = angle + prism_hit.angle
        {nx, ny} = step(prism_hit.x, prism_hit.y, new_angle)

        find_sequence_iter(
          bounds,
          prisms,
          %{angle: new_angle, x: nx, y: ny},
          [prism_hit.id | acc]
        )

      true ->
        {nx, ny} = step(x, y, angle)
        find_sequence_iter(bounds, prisms, %{angle: angle, x: nx, y: ny}, acc)
    end
  end

  defp step(x, y, angle) do
    canonical_angle =
      :math.pi() *
        Integer.mod(trunc(angle * @angle_precision), 360 * @angle_precision) /
        @angle_precision /
        180.0

    {
      x + :math.cos(canonical_angle) * @step,
      y + :math.sin(canonical_angle) * @step
    }
  end

  defp dist(a, b) do
    :math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))
  end
end
