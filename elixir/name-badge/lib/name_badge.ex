defmodule NameBadge do
  def print(id, name, department) do
    # This exercise includes `if` description, implying I should use it,
    # but i'd prefer cond or function with multiple clauses
    printed_department = if department, do: String.upcase(department), else: "OWNER"

    if id do
      "[#{id}] - #{name} - #{printed_department}"
    else
      "#{name} - #{printed_department}"
    end
  end

  # # using cond
  # def print(id, name, department) do
  #   cond do
  #     !id and !department -> "#{name} - OWNER"
  #     !id -> "#{name} - #{String.upcase(department)}"
  #     !department -> "[#{id}] - #{name} - OWNER"
  #     true -> "[#{id}] - #{name} - #{String.upcase(department)}"
  #   end
  # end

  # # using multple clauses
  # def print(id, name, nil), do: print(id, name, "Owner")
  # def print(nil, name, department), do: "#{name} - #{String.upcase(department)}"
  # def print(id, name, department), do: "[#{id}] - #{print(nil, name, department)}"
end
