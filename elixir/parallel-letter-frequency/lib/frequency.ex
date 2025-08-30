defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    processes =
      1..workers
      |> Enum.map(fn _ -> spawn_link(&loop/0) end)

    texts
    |> Enum.zip(Stream.cycle(processes))
    |> Enum.each(fn {text, process} -> send(process, {:count, text}) end)

    processes
    |> Enum.reduce(%{}, fn process, total_count ->
      send(process, {:complete, self()})

      receive do
        text_count ->
          Map.merge(total_count, text_count, fn _k, v1, v2 ->
            v1 + v2
          end)
      end
    end)
  end

  defp loop(counts \\ %{}) do
    receive do
      {:complete, sender} ->
        send(sender, counts)

      {:count, text} ->
        text
        |> String.graphemes()
        |> Enum.reduce(counts, fn char, acc ->
          if String.match?(char, ~r/[[:alpha:]]/iu) do
            Map.update(acc, String.downcase(char), 1, &(&1 + 1))
          else
            acc
          end
        end)
        |> loop()
    end
  end
end
