defmodule Transmission do
  @doc """
  Return the transmission sequence for a message.
  """
  @spec get_transmit_sequence(binary()) :: binary()
  def get_transmit_sequence(<<>>), do: <<>>

  def get_transmit_sequence(<<chunk::7, rest::bitstring>>) do
    <<chunk::7, count_bits(<<chunk::7>>)::1,
      get_transmit_sequence(<<rest::bitstring>>)::bitstring>>
  end

  def get_transmit_sequence(last) do
    <<last::bitstring, 0::integer-size(7 - bit_size(last)), count_bits(<<last::bitstring>>)::1>>
  end

  @doc """
  Return the message decoded from the received transmission.
  """
  @spec decode_message(binary()) :: {:ok, binary()} | {:error, String.t()}
  def decode_message(message) do
    with {:ok, decoded} <- decode_message_recur(message),
         do: {:ok, truncate_message(decoded, trunc(bit_size(message) / 9))}
  end

  defp decode_message_recur(<<>>), do: {:ok, ""}

  defp decode_message_recur(<<byte::8, rest::bitstring>>) do
    with {:ok, rest_decoded} <- decode_message_recur(<<rest::bitstring>>),
         {:ok, decoded_chunk} <- decode_byte(<<byte::8>>),
         do: {:ok, <<decoded_chunk::7, rest_decoded::bitstring>>}
  end

  defp count_bits(<<>>), do: 0
  defp count_bits(<<0::1, rest::bitstring>>), do: count_bits(rest)
  defp count_bits(<<1::1, rest::bitstring>>), do: 1 + count_bits(rest)

  defp decode_byte(<<data::7, _parity::1>> = byte) do
    case rem(count_bits(<<byte::bitstring>>), 2) do
      0 -> {:ok, data}
      1 -> {:error, "wrong parity"}
    end
  end

  defp truncate_message(message, bytes) do
    <<truncated::binary-size(bytes), _rest::bitstring>> = message
    truncated
  end
end
