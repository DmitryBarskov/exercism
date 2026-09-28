defmodule JigsawPuzzle do
  @doc """
  Fill in missing jigsaw puzzle details from partial data
  """

  @type format() :: :landscape | :portrait | :square
  @type t() :: %__MODULE__{
          pieces: pos_integer() | nil,
          rows: pos_integer() | nil,
          columns: pos_integer() | nil,
          format: format() | nil,
          aspect_ratio: float() | nil,
          border: pos_integer() | nil,
          inside: pos_integer() | nil
        }

  defstruct [:pieces, :rows, :columns, :format, :aspect_ratio, :border, :inside]

  @error_contradictory {:error, "Contradictory data"}
  @error_insufficient {:error, "Insufficient data"}

  @spec data(jigsaw_puzzle :: JigsawPuzzle.t()) ::
          {:ok, JigsawPuzzle.t()} | {:error, String.t()}
  def data(jigsaw_puzzle) do
    possible_solutions =
      for {rows, columns} <- infer_rows_and_columns(jigsaw_puzzle),
          expected_pieces = rows * columns,
          expected_aspect_ratio = columns / rows,
          expected_format = format_from_aspect_ratio(expected_aspect_ratio),
          expected_border = 2 * (rows + columns - 2),
          expected_inside = expected_pieces - expected_border,
          is_nil(jigsaw_puzzle.rows) or jigsaw_puzzle.rows == rows,
          is_nil(jigsaw_puzzle.columns) or jigsaw_puzzle.columns == columns,
          is_nil(jigsaw_puzzle.pieces) or jigsaw_puzzle.pieces == expected_pieces,
          is_nil(jigsaw_puzzle.aspect_ratio) or
            jigsaw_puzzle.aspect_ratio == expected_aspect_ratio,
          is_nil(jigsaw_puzzle.format) or jigsaw_puzzle.format == expected_format,
          is_nil(jigsaw_puzzle.border) or jigsaw_puzzle.border == expected_border,
          is_nil(jigsaw_puzzle.inside) or jigsaw_puzzle.inside == expected_inside do
        %JigsawPuzzle{
          rows: rows,
          columns: columns,
          pieces: expected_pieces,
          aspect_ratio: expected_aspect_ratio,
          format: expected_format,
          border: expected_border,
          inside: expected_inside
        }
      end

    case possible_solutions do
      [one] -> {:ok, one}
      [] -> @error_contradictory
      _ -> @error_insufficient
    end
  end

  defguardp not_nil(value) when not is_nil(value)
  defguardp not_nil(v1, v2) when not_nil(v1) and not_nil(v2)

  defp infer_rows_and_columns(%JigsawPuzzle{
         rows: rows,
         columns: columns,
         pieces: pieces,
         aspect_ratio: aspect_ratio,
         border: border,
         inside: inside,
         format: format
       }) do
    cond do
      not_nil(rows, columns) ->
        [{rows, columns}]

      not_nil(rows) and format == :square ->
        [{rows, rows}]

      not_nil(inside) and aspect_ratio == 1 ->
        for {inner_rows, inner_cols} <- [{int_sqrt(inside), int_sqrt(inside)}],
            inner_rows * inner_cols == inside,
            do: {inner_rows + 2, inner_cols + 2}

      not_nil(aspect_ratio, rows) ->
        columns = trunc(rows * aspect_ratio)
        if columns == rows * aspect_ratio, do: [{rows, columns}], else: []

      not_nil(border) ->
        for rows <- 1..div(border, 2),
            columns = div(border, 2) + 2 - rows,
            do: {rows, columns}

      not_nil(pieces) ->
        for rows <- 1..pieces,
            columns = div(pieces, rows),
            rem(pieces, rows) == 0,
            do: {rows, trunc(columns)}

      true ->
        []
    end
  end

  defp format_from_aspect_ratio(aspect_ratio) do
    cond do
      aspect_ratio == 1 -> :square
      aspect_ratio > 1 -> :landscape
      aspect_ratio < 1 -> :portrait
    end
  end

  defp int_sqrt(num), do: trunc(:math.sqrt(num))
end
