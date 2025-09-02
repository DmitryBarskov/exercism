defmodule Username do
  @doc """
  Removes all chars except for lowercase ones and underscore.
  Also replaces German characters with Latin substitues.
  ä becomes ae
  ö becomes oe
  ü becomes ue
  ß becomes ss
  """
  def sanitize(username) do
    username
    |> Enum.flat_map(fn char ->
      case char do
        ?ä -> ~c"ae"
        ?ö -> ~c"oe"
        ?ü -> ~c"ue"
        ?ß -> ~c"ss"
        ?_ -> ~c"_"
        c when ?a <= c and c <= ?z -> [c]
        _ -> []
      end
    end)
  end
end
