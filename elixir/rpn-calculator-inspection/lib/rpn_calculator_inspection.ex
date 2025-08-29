defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    %{input: input, pid: spawn_link(fn -> calculator.(input) end)}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    first_state = Process.flag(:trap_exit, true)

    results =
      inputs
      |> Enum.map(fn input ->
        start_reliability_check(calculator, input)
      end)
      |> Enum.map(fn check_data ->
        await_reliability_check_result(check_data, %{})
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
