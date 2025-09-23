defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part(ast, acc) when is_tuple(ast) and elem(ast, 0) in [:defp, :def] do
    case ast do
      # zero arity with guard
      {_, _, [{:when, _, [{_name, _, nil} | _]} | _]} ->
        {ast, ["" | acc]}

      # with guard
      {_, _, [{:when, _, [{name, _, params} | _]} | _]} ->
        arity = Enum.count(params)
        secret = Atom.to_string(name) |> String.slice(0, arity)
        {ast, [secret | acc]}

      # zero arity
      {_, _, [{_name, _, nil} | _ ]} ->
        {ast, ["" | acc]}

      {_, _, [{name, _, params} | _ ]} ->
        arity = Enum.count(params)
        secret = Atom.to_string(name) |> String.slice(0, arity)
        {ast, [secret | acc]}
    end
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) do
    string
    |> to_ast
    |> Macro.postwalk([], &decode_secret_message_part/2)
    |> elem(1)
    |> Enum.reverse
    |> Enum.join
  end
end
