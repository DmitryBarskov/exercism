defmodule Meetup do
  import Integer

  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    beginning_of_month = Date.new!(year, month, 1)

    first_weekday_of_month =
      1 +
        mod(
          7 + weekday_to_integer(weekday) - Date.day_of_week(beginning_of_month),
          7
        )

    first_weekday = Date.new!(year, month, first_weekday_of_month)

    case schedule do
      :first -> first_weekday
      :second -> Date.add(first_weekday, 7)
      :third -> Date.add(first_weekday, 14)
      :fourth -> Date.add(first_weekday, 21)
      :last -> find_last_weekday_of_month(first_weekday)
      :teenth -> find_teenth_weekday_of_month(first_weekday)
    end
  end

  defp weekday_to_integer(weekday) do
    case weekday do
      :monday -> 1
      :tuesday -> 2
      :wednesday -> 3
      :thursday -> 4
      :friday -> 5
      :saturday -> 6
      :sunday -> 7
    end
  end

  defp find_last_weekday_of_month(date) do
    weekdays_of_month(date)
    |> Enum.find(fn d -> Date.add(d, 7).month != d.month end)
  end

  defp find_teenth_weekday_of_month(date) do
    weekdays_of_month(date)
    |> Enum.find(fn d -> d.day in 13..19 end)
  end

  defp weekdays_of_month(first_weekday) do
    Date.range(first_weekday, Date.end_of_month(first_weekday), 7)
  end
end
