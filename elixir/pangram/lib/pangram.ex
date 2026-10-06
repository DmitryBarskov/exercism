defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    unique_chars = String.upcase(sentence) |> String.to_charlist() |> MapSet.new()

    (?A..?Z) |> Enum.all?(&(MapSet.member?(unique_chars, &1)))
  end
end
