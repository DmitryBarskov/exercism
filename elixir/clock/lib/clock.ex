defmodule Clock do
  import Kernel, except: [to_string: 1]
  import Integer, only: [mod: 2]

  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    minutes = absolute_minutes_in_day(hours_to_minutes(hour) + minute)

    %Clock{
      hour: minutes_to_hours(minutes),
      minute: absolute_minutes_in_hour(minutes)
    }
  end

  defp hours_to_minutes(hours), do: mod(hours, 24) * 60
  defp minutes_to_hours(minutes), do: div(minutes, 60)
  defp absolute_minutes_in_day(minutes), do: mod(minutes, 24 * 60)
  defp absolute_minutes_in_hour(minutes), do: mod(minutes, 60)

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    Clock.new(hour, minute + add_minute)
  end

  defimpl String.Chars, for: Clock do
    defp format_time_component(time) do
      String.pad_leading(Integer.to_string(time), 2, "0")
    end

    def to_string(%Clock{hour: hour, minute: minute}) do
      hour = format_time_component(hour)
      minute = format_time_component(minute)
      "#{hour}:#{minute}"
    end
  end
end
