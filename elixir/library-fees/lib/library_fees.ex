defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    Time.before?(NaiveDateTime.to_time(datetime), ~T[12:00:00])
  end

  def return_date(checkout_datetime) do
    days_later =
      if before_noon?(checkout_datetime), do: 28, else: 29

    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.shift(day: days_later)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    Date.diff(actual_return_datetime, planned_return_date) |> max(0)
  end

  def monday?(datetime) do
    datetime
    |> NaiveDateTime.to_date()
    |> Date.day_of_week()
    |> then(&(&1 == 1))
  end

  def calculate_late_fee(checkout, return, rate) do
    planned_return = datetime_from_string(checkout) |> return_date()
    return = datetime_from_string(return)
    base_fee = days_late(planned_return, return) * rate

    if monday?(return), do: div(base_fee, 2), else: base_fee
  end
end
