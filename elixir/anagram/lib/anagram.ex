defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    lower_base = String.downcase(base)
    target_freq = char_count(lower_base)

    Enum.filter(
      candidates,
      fn candidate ->
        lower_candidate = String.downcase(candidate)
        char_count(lower_candidate) == target_freq and lower_candidate != lower_base
      end
    )
  end

  defp char_count(str), do: str |> String.to_charlist() |> Enum.frequencies()
end
