defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    %{input: input, pid: spawn_link(fn -> calculator.(input) end)}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    result =
      receive do
        {:EXIT, ^pid, :normal} -> :ok
        {:EXIT, ^pid, _} -> :error
      after
        100 -> :timeout
      end

    Map.put(results, input, result)
  end

  def reliability_check(calculator, inputs) do
    first_state = Process.flag(:trap_exit, true)

    results =
      inputs
      |> Enum.map(fn input -> start_reliability_check(calculator, input) end)
      |> Enum.map(fn input_and_pid ->
        await_reliability_check_result(input_and_pid, %{})
      end)
      |> Enum.reduce(%{}, &Map.merge/2)

    true = Process.flag(:trap_exit, first_state)
    results
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input -> Task.async(fn -> calculator.(input) end) end)
    |> Task.await_many(100)
  end
end
