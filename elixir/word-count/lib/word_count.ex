defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    Enum.frequencies(
      Regex.split(
        ~r/(?<!\w)'|'(?!\w)|[:!?\s_,.&@$%^]+/,
        String.downcase(sentence),
        trim: true
      )
    )
  end
end
