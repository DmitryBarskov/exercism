# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(_opts \\ []) do
    Agent.start(fn -> {0, %{}} end)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {_, registrations} -> Map.values(registrations) end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(
      pid,
      fn {last_id, registrations} ->
        next_id = last_id + 1
        registration = %Plot{plot_id: next_id, registered_to: register_to}
        state = {
          next_id,
          Map.put(registrations, next_id, registration)
        }
        {state, state}
      end
    ) |> then(fn {last_id, registrations} -> registrations[last_id] end)
  end

  def release(pid, plot_id) do
    Agent.cast(
      pid,
      fn {last_id, registrations} ->
        {last_id, Map.pop(registrations, plot_id) |> elem(1)}
      end
    )
  end

  def get_registration(pid, plot_id) do
    Agent.get(
      pid,
      fn {_, registrations} ->
        Map.get(registrations, plot_id,  {:not_found, "plot is unregistered"})
      end
    )
  end
end
