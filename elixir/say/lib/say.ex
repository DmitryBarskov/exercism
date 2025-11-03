defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(0), do: {:ok, "zero"}
  def in_english(num) when num < 0, do: {:error, "number is out of range"}
  def in_english(num) when num > 999_999_999_999, do: {:error, "number is out of range"}

  def in_english(number) do
    {:ok, words(number) |> String.trim()}
  end

  def words(0), do: ""
  def words(1), do: "one"
  def words(2), do: "two"
  def words(3), do: "three"
  def words(4), do: "four"
  def words(5), do: "five"
  def words(6), do: "six"
  def words(7), do: "seven"
  def words(8), do: "eight"
  def words(9), do: "nine"

  def words(10), do: "ten"
  def words(11), do: "eleven"
  def words(12), do: "twelve"
  def words(13), do: "thirteen"
  def words(14), do: "fourteen"
  def words(15), do: "fifteen"
  def words(16), do: "sixteen"
  def words(17), do: "seventeen"
  def words(18), do: "eighteen"
  def words(19), do: "nineteen"

  def words(20), do: "twenty"
  def words(30), do: "thirty"
  def words(40), do: "forty"
  def words(50), do: "fifty"
  def words(60), do: "sixty"
  def words(70), do: "seventy"
  def words(80), do: "eighty"
  def words(90), do: "ninety"

  def words(number) when number >= 1_000_000_000 do
    words(div(number, 1_000_000_000)) <> " billion " <> words(rem(number, 1_000_000_000))
  end

  def words(number) when number >= 1_000_000 do
    words(div(number, 1_000_000)) <> " million " <> words(rem(number, 1_000_000))
  end

  def words(number) when number >= 1_000 do
    words(div(number, 1_000)) <> " thousand " <> words(rem(number, 1_000))
  end

  def words(number) when number >= 100 do
    words(div(number, 100)) <> " hundred " <> words(rem(number, 100))
  end

  def words(number) when number >= 20 do
    words(number - rem(number, 10)) <> "-" <> words(rem(number, 10))
  end
end
