defmodule React do
  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells) do
    GenServer.start_link(__MODULE__, cells)
  end

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name) do
    GenServer.call(cells, {:compute, cell_name})
  end

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value) do
    GenServer.cast(cells, {:set, cell_name, value})
  end

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    GenServer.cast(cells, {:add_callback, cell_name, callback_name, callback})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    GenServer.cast(cells, {:remove_callback, cell_name, callback_name})
  end

  defmodule InputCell do
    defstruct [:name, :value]

    def new({:input, name, value}), do: new(name, value)

    def new(cell_name, value), do: %InputCell{name: cell_name, value: value}
  end

  defmodule OutputCell do
    defstruct [:name, :dependencies, :formula]

    def new({:output, name, dependencies, formula}) do
      %OutputCell{name: name, dependencies: dependencies, formula: formula}
    end
  end

  defmodule Callback do
    defstruct [:name, :cell, :func]

    def new(cell_name, callback_name, callback) do
      %Callback{name: callback_name, cell: cell_name, func: callback}
    end

    def call(callback, value) do
      callback.func.(callback.name, value)
    end
  end

  defmodule State do
    defstruct cells: %{}, callbacks: []

    def new(cells) when is_list(cells) do
      %State{
        cells:
          Map.new(cells, fn
            {:input, name, _val} = cell -> {name, InputCell.new(cell)}
            {:output, name, _deps, _f} = cell -> {name, OutputCell.new(cell)}
          end),
        callbacks: []
      }
    end

    def add_callback(state, cell_name, callback_name, callback) do
      %State{
        cells: state.cells,
        callbacks: [
          Callback.new(cell_name, callback_name, callback) | state.callbacks
        ]
      }
    end

    def remove_callback(state, cell_name, callback_name) do
      %State{
        cells: state.cells,
        callbacks:
          Enum.filter(state.callbacks, fn callback ->
            callback.cell != cell_name or callback.name != callback_name
          end)
      }
    end
  end

  use GenServer

  @impl GenServer
  def init(cells) do
    {:ok, State.new(cells)}
  end

  @impl GenServer
  def handle_call({:compute, cell_name}, _from, state) do
    {:reply, do_compute(state.cells, cell_name), state}
  end

  @impl GenServer
  def handle_cast({:set, cell_name, value}, %State{cells: cells, callbacks: callbacks}) do
    new_cells = Map.put(cells, cell_name, InputCell.new(cell_name, value))

    Enum.each(callbacks, fn callback ->
      old_value = do_compute(cells, callback.cell)
      new_value = do_compute(new_cells, callback.cell)

      if old_value != new_value do
        Callback.call(callback, new_value)
      end
    end)

    {:noreply, %State{cells: new_cells, callbacks: callbacks}}
  end

  @impl GenServer
  def handle_cast({:add_callback, cell_name, callback_name, callback}, state) do
    {
      :noreply,
      State.add_callback(state, cell_name, callback_name, callback)
    }
  end

  @impl GenServer
  def handle_cast({:remove_callback, cell_name, callback_name}, state) do
    {
      :noreply,
      State.remove_callback(state, cell_name, callback_name)
    }
  end

  defp do_compute(cells, cell_name) do
    case Map.get(cells, cell_name) do
      %InputCell{value: value} ->
        value

      %OutputCell{dependencies: dependencies, formula: formula} ->
        without_cell = Map.delete(cells, cell_name)
        arguments = Enum.map(dependencies, fn param -> do_compute(without_cell, param) end)
        apply(formula, arguments)

      nil ->
        raise "Cell #{cell_name} not found. It may indicate a circular dependency"
    end
  end
end
