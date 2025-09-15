defmodule VariableLengthQuantity do
  import Bitwise, only: [bsr: 2, band: 2, bsl: 2, bor: 2]

  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.map(&chunks_of_7/1)
    |> Enum.flat_map(&encode_single_number/1)
    |> IO.iodata_to_binary()
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: decode(bytes, 0, [])

  @spec decode(bytes :: binary, current_number :: integer, acc :: [integer]) ::
          {:ok, [integer]} | {:error, String.t()}
  defp decode(<<1::1, _last_chunk::7>>, _, _) do
    {:error, "incomplete sequence"}
  end

  defp decode(<<0::1, last_chunk::7>>, current_number, acc) do
    last_number = bsl(current_number, 7) |> bor(last_chunk)
    {:ok, [last_number | acc] |> Enum.reverse()}
  end

  defp decode(<<1::1, chunk::7, rest::binary>>, current_number, acc) do
    decode(rest, bsl(current_number, 7) |> bor(chunk), acc)
  end

  defp decode(<<0::1, chunk::7, rest::binary>>, current_number, acc) do
    decode(rest, 0, [bsl(current_number, 7) |> bor(chunk) | acc])
  end

  # splits a number into 7 bit chunks, e.g. 42 -> [42], 127 -> [127], 128 -> [1, 0]
  @spec chunks_of_7(number :: integer) :: [integer]
  defp chunks_of_7(0), do: [0]
  defp chunks_of_7(number), do: chunks_of_7(number, [])

  defp chunks_of_7(0, acc), do: acc

  defp chunks_of_7(num, acc) do
    chunks_of_7(bsr(num, 7), [band(num, 0b0111_1111) | acc])
  end

  # encodes 7-bit chunks of a single integer into VLQ bytes
  @spec encode_single_number(chunks :: [integer]) :: [binary]
  defp encode_single_number(chunks), do: encode_single_number(chunks, [])

  defp encode_single_number([last_chunk], acc) do
    [<<0::1, last_chunk::7>> | acc] |> Enum.reverse()
  end

  defp encode_single_number([chunk | chunks], acc) do
    encode_single_number(chunks, [<<1::1, chunk::7>> | acc])
  end
end
