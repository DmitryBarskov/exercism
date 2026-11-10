defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    spawn(BankAccount, :loop, [0])
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    with :ok <- check_alive(account) do
      send(account, {:close, self()})
    end
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    send_and_receive(account, :balance)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) do
    send_and_receive(account, :deposit, amount)
  end

  @doc """
  Subtract the given amount from the accounts balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) do
    send_and_receive(account, :withdraw, amount)
  end

  def loop(balance) do
    receive do
      {:balance, sender_pid} ->
        send(sender_pid, balance)
        loop(balance)

      {:deposit, sender_pid, amount} ->
        if amount <= 0 do
          send(sender_pid, {:error, :amount_must_be_positive})
          loop(balance)
        else
          send(sender_pid, :ok)
          loop(balance + amount)
        end

      {:withdraw, sender_pid, amount} ->
        cond do
          amount <= 0 ->
            send(sender_pid, {:error, :amount_must_be_positive})
            loop(balance)

          balance < amount ->
            send(sender_pid, {:error, :not_enough_balance})
            loop(balance)

          true ->
            send(sender_pid, :ok)
            loop(balance - amount)
        end

      {:close, sender_pid} ->
        send(sender_pid, :ok)

      something_else ->
        raise "Don't know how to react to #{something_else.inspect}"
    end
  end

  defp check_alive(account) do
    if Process.alive?(account) do
      :ok
    else
      {:error, :account_closed}
    end
  end

  defp send_and_receive(account, message) do
    with :ok <- check_alive(account) do
      send(account, {message, self()})

      receive do
        any -> any
      after
        1000 -> "timeout on #{message}"
      end
    end
  end

  defp send_and_receive(account, message, argument) do
    with :ok <- check_alive(account) do
      send(account, {message, self(), argument})

      receive do
        any -> any
      after
        1000 -> raise "timeout on #{message} with #{argument}"
      end
    end
  end
end
