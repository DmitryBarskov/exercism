defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str), do: check_brackets(str, [])

  @all_brackets ~c([]{}(\))

  defp check_brackets("", []), do: true
  defp check_brackets("", _not_empty), do: false

  defp check_brackets(<<symbol, rest::bitstring>>, stack) when symbol not in @all_brackets,
    do: check_brackets(rest, stack)

  defp check_brackets(<<"[", rest::bitstring>>, stack),
    do: check_brackets(rest, [:brackets | stack])

  defp check_brackets(<<"{", rest::bitstring>>, stack),
    do: check_brackets(rest, [:braces | stack])

  defp check_brackets(<<"(", rest::bitstring>>, stack),
    do: check_brackets(rest, [:parentheses | stack])

  defp check_brackets(<<"]", rest::bitstring>>, [:brackets | stack]),
    do: check_brackets(rest, stack)

  defp check_brackets(<<"}", rest::bitstring>>, [:braces | stack]),
    do: check_brackets(rest, stack)

  defp check_brackets(<<")", rest::bitstring>>, [:parentheses | stack]),
    do: check_brackets(rest, stack)

  defp check_brackets(_, _), do: false
end
