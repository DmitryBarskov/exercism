defmodule ProteinTranslation do
  @invalid_rna {:error, "invalid RNA"}
  @invalid_codon {:error, "invalid codon"}
  @valid_bases ~c(ACGU)

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna), do: of_rna(rna, [])

  defp of_rna("", proteins), do: {:ok, Enum.reverse(proteins)}

  defp of_rna(<<codon::binary-size(3), rest::bitstring>>, proteins) do
    case of_codon(codon) do
      {:ok, "STOP"} ->
        {:ok, Enum.reverse(proteins)}

      {:ok, amino} ->
        of_rna(rest, [amino | proteins])

      {:error, _} = err ->
        if valid_rna?(codon) do
          err
        else
          @invalid_rna
        end
    end
  end

  defp of_rna(_, _), do: @invalid_rna

  defp valid_rna?(codon),
    do: Enum.all?(to_charlist(codon), fn base -> base in @valid_bases end)

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case codon do
      "UGU" -> {:ok, "Cysteine"}
      "UGC" -> {:ok, "Cysteine"}
      "UUA" -> {:ok, "Leucine"}
      "UUG" -> {:ok, "Leucine"}
      "AUG" -> {:ok, "Methionine"}
      "UUU" -> {:ok, "Phenylalanine"}
      "UUC" -> {:ok, "Phenylalanine"}
      "UCU" -> {:ok, "Serine"}
      "UCC" -> {:ok, "Serine"}
      "UCA" -> {:ok, "Serine"}
      "UCG" -> {:ok, "Serine"}
      "UGG" -> {:ok, "Tryptophan"}
      "UAU" -> {:ok, "Tyrosine"}
      "UAC" -> {:ok, "Tyrosine"}
      "UAA" -> {:ok, "STOP"}
      "UAG" -> {:ok, "STOP"}
      "UGA" -> {:ok, "STOP"}
      _ -> @invalid_codon
    end
  end
end
