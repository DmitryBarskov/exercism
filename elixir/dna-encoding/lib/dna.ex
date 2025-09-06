defmodule DNA do
  def encode_nucleotide(?\s), do: 0b0000
  def encode_nucleotide(?A), do: 0b0001
  def encode_nucleotide(?C), do: 0b0010
  def encode_nucleotide(?G), do: 0b0100
  def encode_nucleotide(?T), do: 0b1000

  def decode_nucleotide(0b0000), do: ?\s
  def decode_nucleotide(0b0001), do: ?A
  def decode_nucleotide(0b0010), do: ?C
  def decode_nucleotide(0b0100), do: ?G
  def decode_nucleotide(0b1000), do: ?T

  def encode(dna), do: encode(dna, "")

  defp encode([], acc), do: acc
  defp encode([amino | rest], acc) do
    encode(rest, <<acc::bitstring, encode_nucleotide(amino)::4>>)
  end

  def decode(dna), do: decode(dna, [])

  defp decode("", acc), do: reverse(acc)
  defp decode(<<amino::4, rest::bitstring>>, acc) do
    decode(rest, [decode_nucleotide(amino) | acc])
  end

  defp reverse(list, acc \\ [])
  defp reverse([], acc), do: acc
  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])
end
