defmodule LogLevel do
  def to_label(log_code, legacy?) do
    cond do
      log_code == 0 and not legacy? -> :trace
      log_code == 1 -> :debug
      log_code == 2 -> :info
      log_code == 3 -> :warning
      log_code == 4 -> :error
      log_code == 5 and not legacy? -> :fatal
      true -> :unknown
    end
  end

  def alert_recipient(level, legacy?) do
    cond do
      to_label(level, legacy?) == :error or to_label(level, legacy?) == :fatal -> :ops
      legacy? and to_label(level, legacy?) == :unknown -> :dev1
      not legacy? and to_label(level, legacy?) == :unknown -> :dev2
      true -> false
    end
  end
end
