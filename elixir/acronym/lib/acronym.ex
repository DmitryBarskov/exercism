defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string), do: abbreviate(String.graphemes(string), :not_in_word)

  @word_terminators [" ", "-", "_"]

  @spec abbreviate([String.grapheme()], :not_in_word | :in_word) :: String.t()
  def abbreviate([], _),
    do: ""

  def abbreviate([term | rest], _state) when term in @word_terminators,
    do: abbreviate(rest, :not_in_word)

  def abbreviate([first_letter | rest], :not_in_word),
    do: String.upcase(first_letter) <> abbreviate(rest, :in_word)

  def abbreviate([_ | rest], :in_word),
    do: abbreviate(rest, :in_word)
end
