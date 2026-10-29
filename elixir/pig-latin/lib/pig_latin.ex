defmodule PigLatin do
  @vowels [?a, ?e, ?i, ?o, ?u]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    String.split(phrase)
    |> Enum.map(fn word ->
      cond do
        rule_one?(word) -> rule_one(word)
        rule_three?(word) -> rule_three(word)
        rule_four?(word) -> rule_four(word)
        rule_two?(word) -> rule_two(word)
      end
    end)
    |> Enum.join(" ")
  end

  defguardp vowel?(char) when char in @vowels
  defguardp consonant?(char) when char not in @vowels

  defp rule_one?(<<"xr", _rest::binary>>), do: true
  defp rule_one?(<<"yt", _rest::binary>>), do: true
  defp rule_one?(<<char, _rest::binary>>) when vowel?(char), do: true
  defp rule_one?(_), do: false

  defp rule_one(word), do: word <> "ay"

  defp rule_two?(<<char, _rest::binary>>), do: consonant?(char)
  defp rule_two?(_), do: false

  defp rule_two(<<char, rest::binary>>) when consonant?(char),
    do: rule_two(<<rest::bitstring, char>>)

  defp rule_two(word), do: word <> "ay"

  defp rule_three?(<<"qu", _rest::binary>>), do: true
  defp rule_three?(<<char, rest::binary>>) when consonant?(char), do: rule_three?(rest)
  defp rule_three?(_), do: false

  defp rule_three(<<"qu", rest::binary>>), do: rest <> "quay"

  defp rule_three(<<char, rest::binary>>) when consonant?(char),
    do: rule_three(<<rest::bitstring, char>>)

  defp rule_four?(<<char, rest::binary>>) when consonant?(char), do: soft_rule_four?(rest)
  defp rule_four?(_), do: false

  defp soft_rule_four?(<<"y", _rest::binary>>), do: true
  defp soft_rule_four?(<<char, rest::binary>>) when consonant?(char), do: soft_rule_four?(rest)
  defp soft_rule_four?(_), do: false

  defp rule_four(<<"y", _rest::binary>> = word), do: word <> "ay"

  defp rule_four(<<char, rest::binary>>) when consonant?(char),
    do: rule_four(<<rest::bitstring, char>>)
end
