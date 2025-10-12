defmodule SecretHandshake do
  import Bitwise, only: [band: 2]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """

  @spec commands(code :: integer) :: list(String.t())
  def commands(code), do: commands(band(code, 0b11111), [])

  defp commands(code, acc) when band(code, 0b01000) > 0,
    do: commands(band(code, 0b10111), ["jump" | acc])

  defp commands(code, acc) when band(code, 0b00100) > 0,
    do: commands(band(code, 0b11011), ["close your eyes" | acc])

  defp commands(code, acc) when band(code, 0b00010) > 0,
    do: commands(band(code, 0b11101), ["double blink" | acc])

  defp commands(code, acc) when band(code, 0b00001) > 0,
    do: commands(band(code, 0b11110), ["wink" | acc])

  defp commands(code, acc) when band(code, 0b10000) > 0,
    do: Enum.reverse(acc)

  defp commands(0, acc), do: acc
end
