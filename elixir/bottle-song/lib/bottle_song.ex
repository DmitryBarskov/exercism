defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    start_bottle..(start_bottle - take_down + 1)//-1
    |> Enum.map(&verse/1)
    |> Enum.join("\n\n")
  end

  defp verse(number) do
    first_line =
      "#{String.capitalize(number_in_words(number))} green #{pluralize_bottle(number)} hanging on the wall"

    """
    #{first_line},
    #{first_line},
    And if one green bottle should accidentally fall,
    There'll be #{number_in_words(number - 1)} green #{pluralize_bottle(number - 1)} hanging on the wall.
    """
    |> String.trim()
  end

  defp number_in_words(number) do
    case number do
      0 -> "no"
      1 -> "one"
      2 -> "two"
      3 -> "three"
      4 -> "four"
      5 -> "five"
      6 -> "six"
      7 -> "seven"
      8 -> "eight"
      9 -> "nine"
      10 -> "ten"
    end
  end

  defp pluralize_bottle(1), do: "bottle"
  defp pluralize_bottle(_), do: "bottles"
end
