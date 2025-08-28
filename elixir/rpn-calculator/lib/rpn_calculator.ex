defmodule RPNCalculator do
  def calculate!(stack, operation) do
    operation.(stack)
  end

  def calculate(stack, operation) do
    try do
      result = calculate!(stack, operation)
      {:ok, result}
    rescue
      _ -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      result = calculate!(stack, operation)
      {:ok, result}
    rescue
      err -> {:error, Exception.message(err)}
    end
  end
end
