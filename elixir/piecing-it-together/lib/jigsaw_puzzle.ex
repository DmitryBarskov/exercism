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

  @spec data(jigsaw_puzzle :: JigsawPuzzle.t()) ::
          {:ok, JigsawPuzzle.t()} | {:error, String.t()}
  def data(jigsaw_puzzle) do
    with {:ok, jigsaw_puzzle} <- ensure_aspect_ratio(jigsaw_puzzle),
         {:ok, jigsaw_puzzle} <- ensure_pieces(jigsaw_puzzle),
         {:ok, jigsaw_puzzle} <- ensure_columns(jigsaw_puzzle),
         {:ok, jigsaw_puzzle} <- ensure_rows(jigsaw_puzzle),
         {:ok, jigsaw_puzzle} <- ensure_border(jigsaw_puzzle),
         {:ok, jigsaw_puzzle} <- ensure_inside(jigsaw_puzzle),
         {:ok, jigsaw_puzzle} <- ensure_format(jigsaw_puzzle) do
      {:ok, jigsaw_puzzle}
    end
  end

  @error_contradictory {:error, "Contradictory data"}
  @error_insufficient {:error, "Insufficient data"}

  defguardp not_nil(value) when not is_nil(value)
  defguardp not_nil(v1, v2) when not_nil(v1) and not_nil(v2)
  defguardp not_nil(v1, v2, v3) when not_nil(v1) and not_nil(v2) and not_nil(v3)

  defp ensure_aspect_ratio(jigsaw_puzzle) do
    case jigsaw_puzzle do
      %{aspect_ratio: aspect_ratio, columns: columns, rows: rows}
      when not_nil(aspect_ratio, columns, rows) ->
        if columns / rows == aspect_ratio do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{columns: columns, rows: rows}
      when not_nil(columns, rows) ->
        {:ok, %{jigsaw_puzzle | aspect_ratio: columns / rows}}

      %{aspect_ratio: aspect_ratio, format: format}
      when not_nil(aspect_ratio, format) ->
        cond do
          format == :square && aspect_ratio == 1 -> {:ok, jigsaw_puzzle}
          format == :portrait && aspect_ratio < 1 -> {:ok, jigsaw_puzzle}
          format == :landscape && aspect_ratio > 1 -> {:ok, jigsaw_puzzle}
          true -> @error_contradictory
        end

      %{format: :portrait, pieces: pieces, border: border, aspect_ratio: nil}
      when not_nil(pieces, border) ->
        solutions =
          for columns <- 1..pieces,
              rows = pieces / columns,
              rem(pieces, columns) == 0,
              rows > columns,
              2 * (columns + rows - 2) == border do
            %{jigsaw_puzzle | aspect_ratio: columns / rows}
          end

        case solutions do
          [single] -> {:ok, single}
          [] -> @error_contradictory
          _ -> @error_insufficient
        end

      %{format: :square} ->
        {:ok, %{jigsaw_puzzle | aspect_ratio: 1.0}}

      %{aspect_ratio: aspect_ratio}
      when not_nil(aspect_ratio) ->
        # cannot verify
        {:ok, jigsaw_puzzle}

      _ ->
        @error_insufficient
    end
  end

  defp ensure_pieces(jigsaw_puzzle) do
    case jigsaw_puzzle do
      # infer data from columns and rows
      %{pieces: pieces, columns: columns, rows: rows}
      when not_nil(pieces, columns, rows) ->
        if columns * rows == pieces do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{columns: columns, rows: rows}
      when not_nil(columns, rows) ->
        {:ok, %{jigsaw_puzzle | pieces: columns * rows}}

      # infer data from columns and aspect_ratio
      %{columns: columns, aspect_ratio: aspect_ratio, pieces: pieces}
      when not_nil(columns, aspect_ratio, pieces) ->
        if columns * aspect_ratio * columns == pieces do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{columns: columns, aspect_ratio: aspect_ratio}
      when not_nil(columns, aspect_ratio) ->
        {:ok, %{jigsaw_puzzle | pieces: columns * aspect_ratio * columns}}

      # infer data from rows and aspect_ratio
      %{rows: rows, aspect_ratio: aspect_ratio, pieces: pieces}
      when not_nil(rows, aspect_ratio, pieces) ->
        if rows * aspect_ratio * rows == pieces do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{rows: rows, aspect_ratio: aspect_ratio}
      when not_nil(rows, aspect_ratio) ->
        {:ok, %{jigsaw_puzzle | pieces: rows * aspect_ratio * rows}}

      # infer data from border and inside
      %{pieces: pieces, border: border, inside: inside}
      when not_nil(pieces, border, inside) ->
        if border + inside == pieces do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      # infer data from aspect_ratio and inside
      %{pieces: pieces, aspect_ratio: aspect_ratio, inside: inside}
      when not_nil(pieces, inside) and aspect_ratio == 1 ->
        if :math.sqrt(pieces) == :math.sqrt(inside) + 2 do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{aspect_ratio: aspect_ratio, inside: inside}
      when not_nil(inside) and aspect_ratio == 1 ->
        {
          :ok,
          %{jigsaw_puzzle | pieces: Integer.pow(trunc(:math.sqrt(inside)) + 2, 2)}
        }

      # infer data from border and inside
      %{border: border, inside: inside}
      when not_nil(border, inside) ->
        {:ok, %{jigsaw_puzzle | pieces: border + inside}}

      %{pieces: pieces}
      when not_nil(pieces) ->
        # cannot verify
        {:ok, jigsaw_puzzle}

      _ ->
        @error_insufficient
    end
  end

  defp ensure_columns(jigsaw_puzzle) do
    case jigsaw_puzzle do
      # r - rows, c - columns, p = pieces, a = aspect_ratio
      # given: a = c / r, p = r * c
      # find: c
      # r = c / a
      # p = (c / a) * c
      # p = c^2 / a
      # a * p = c^2
      # c = sqrt(a * p)
      %{pieces: pieces, aspect_ratio: aspect_ratio, columns: columns}
      when not_nil(pieces, aspect_ratio, columns) ->
        if :math.sqrt(aspect_ratio * pieces) == columns do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{rows: rows, aspect_ratio: aspect_ratio, columns: columns}
      when not_nil(rows, aspect_ratio, columns) ->
        if rows * aspect_ratio == columns do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{rows: rows, aspect_ratio: aspect_ratio}
      when not_nil(rows, aspect_ratio) ->
        {:ok, %{jigsaw_puzzle | columns: rows * aspect_ratio}}

      %{format: :square, rows: rows, columns: nil}
      when not_nil(rows) ->
        {:ok, %{jigsaw_puzzle | columns: rows}}

      %{format: :square, rows: rows, columns: _}
      when not_nil(rows) ->
        @error_contradictory

      %{pieces: pieces, aspect_ratio: aspect_ratio}
      when not_nil(pieces, aspect_ratio) ->
        {:ok, %{jigsaw_puzzle | columns: :math.sqrt(aspect_ratio * pieces)}}

      _ ->
        @error_insufficient
    end
  end

  defp ensure_rows(jigsaw_puzzle) do
    case jigsaw_puzzle do
      %{pieces: pieces, columns: columns, rows: rows}
      when not_nil(pieces, columns, rows) ->
        if rows * columns == pieces do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{pieces: pieces, columns: columns}
      when not_nil(pieces, columns) ->
        {:ok, %{jigsaw_puzzle | rows: pieces / columns}}

      # TODO: come up with other methods to verify/fill rows

      %{rows: rows}
      when not_nil(rows) ->
        # cannot verify
        {:ok, jigsaw_puzzle}

      _ ->
        @error_insufficient
    end
  end

  defp ensure_border(jigsaw_puzzle) do
    case jigsaw_puzzle do
      %{border: border, columns: columns, rows: rows}
      when not_nil(border, columns, rows) ->
        if 2 * (columns + rows - 2) == border do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{columns: columns, rows: rows}
      when not_nil(columns, rows) ->
        {:ok, %{jigsaw_puzzle | border: 2 * (columns + rows - 2)}}

      %{border: border}
      when not_nil(border) ->
        # cannot verify
        {:ok, jigsaw_puzzle}

      _ ->
        @error_insufficient
    end
  end

  defp ensure_inside(jigsaw_puzzle) do
    case jigsaw_puzzle do
      %{pieces: pieces, border: border, inside: inside}
      when not_nil(pieces, border, inside) ->
        if border + inside == pieces do
          {:ok, jigsaw_puzzle}
        else
          @error_contradictory
        end

      %{pieces: pieces, border: border}
      when not_nil(pieces, border) ->
        {:ok, %{jigsaw_puzzle | inside: pieces - border}}

      _ ->
        @error_insufficient
    end
  end

  defp ensure_format(jigsaw_puzzle) do
    case jigsaw_puzzle do
      %{format: format, aspect_ratio: aspect_ratio}
      when not_nil(format, aspect_ratio) ->
        cond do
          format == :square && aspect_ratio == 1 -> {:ok, jigsaw_puzzle}
          format == :landscape && aspect_ratio > 1 -> {:ok, jigsaw_puzzle}
          format == :portrait && aspect_ratio < 1 -> {:ok, jigsaw_puzzle}
          true -> @error_contradictory
        end

      %{aspect_ratio: aspect_ratio}
      when not_nil(aspect_ratio) and aspect_ratio == 1 ->
        {:ok, %{jigsaw_puzzle | format: :square}}

      %{aspect_ratio: aspect_ratio}
      when not_nil(aspect_ratio) and aspect_ratio > 1 ->
        {:ok, %{jigsaw_puzzle | format: :landscape}}

      %{aspect_ratio: aspect_ratio}
      when not_nil(aspect_ratio) and aspect_ratio < 1 ->
        {:ok, %{jigsaw_puzzle | format: :portrait}}

      _ ->
        @error_insufficient
    end
  end
end
