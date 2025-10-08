defmodule TakeANumberDeluxe do
  use GenServer

  alias TakeANumberDeluxe.Queue
  alias TakeANumberDeluxe.State

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(opts) do
    min_number = opts[:min_number]
    max_number = opts[:max_number]
    auto_shutdown_timeout = opts[:auto_shutdown_timeout] || :infinity
    new_state = State.new(min_number, max_number, auto_shutdown_timeout)

    with {:ok, state} <- new_state,
         do: GenServer.start_link(__MODULE__, state)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, {:report_state})
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, {:queue_new_number})
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.call(machine, {:reset_state})
  end

  # Server callbacks

  @impl GenServer
  def init(state) do
    {:ok, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call({:report_state}, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  def handle_call({:queue_new_number}, _from, state) do
    reply = State.queue_new_number(state)

    case reply do
      {:ok, next_number, new_state} ->
        {:reply, {:ok, next_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, error} ->
        {:reply, {:error, error}, state, state.auto_shutdown_timeout}
    end
  end

  def handle_call({:serve_next_queued_number, number}, _from, state) do
    reply = State.serve_next_queued_number(state, number)

    case reply do
      {:error, error} -> {:reply, {:error, error}, state, state.auto_shutdown_timeout}
      {:ok, num, new_state} -> {:reply, {:ok, num}, new_state, new_state.auto_shutdown_timeout}
    end
  end

  def handle_call({:reset_state}, _from, state) do
    {:reply, :ok, %State{state | queue: Queue.new()}, state.auto_shutdown_timeout}
  end

  def handle_call(_, _from, state), do: {:noreply, state, state.auto_shutdown_timeout}

  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}
end
