defmodule Bob do
  @doc """
  - **"Sure."**
    This is his response if you ask him a question, such as "How are you?"
    The convention used for questions is that it ends with a question mark.
  - **"Whoa, chill out!"**
    This is his answer if you YELL AT HIM.
    The convention used for yelling is ALL CAPITAL LETTERS.
  - **"Calm down, I know what I'm doing!"**
    This is what he says if you yell a question at him.
  - **"Fine. Be that way!"**
    This is how he responds to silence.
    The convention used for silence is nothing, or various combinations of whitespace characters.
  - **"Whatever."**
    This is what he answers to anything else.
  """
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)

    cond do
      silence?(input) -> "Fine. Be that way!"
      all_capital?(input) and question?(input) -> "Calm down, I know what I'm doing!"
      all_capital?(input) and not question?(input) -> "Whoa, chill out!"
      not all_capital?(input) and question?(input) -> "Sure."
      true -> "Whatever."
    end
  end

  defp question?(input), do: String.ends_with?(input, "?")

  defp all_capital?(input) do
    String.upcase(input) == input and String.downcase(input) != input
  end

  defp silence?(""), do: true
  defp silence?(_), do: false
end
