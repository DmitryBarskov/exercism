defmodule LineUp do
  @doc """
  Formats a full ticket sentence for the given name and number, including
  the person's name, the ordinal form of the number, and fixed descriptive text.
  """
  @spec format(name :: String.t(), number :: pos_integer()) :: String.t()
  def format(name, number) do
    "#{name}, you are the #{ordinal(number)} customer we serve today. Thank you!"
  end

  defp ordinal(number) do
    case {Integer.mod(number, 100), Integer.mod(number, 10)} do
      {11, _} -> "#{number}th"
      {12, _} -> "#{number}th"
      {13, _} -> "#{number}th"
      {_, 1} -> "#{number}st"
      {_, 2} -> "#{number}nd"
      {_, 3} -> "#{number}rd"
      _ -> "#{number}th"
    end
  end
end
