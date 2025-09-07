defmodule RPG.CharacterSheet do
  def welcome() do
    IO.puts("Welcome! Let's fill out your character sheet together.")
  end

  def ask_name() do
    ask_character("name")
  end

  def ask_class() do
    ask_character("class")
  end

  def ask_level() do
    ask_character("level") |> Integer.parse() |> elem(0)
  end

  def run() do
    welcome()
    name = ask_name()
    class = ask_class()
    level = ask_level()

    character = %{class: class, level: level, name: name}
    IO.inspect(character, label: "Your character")
  end

  defp ask_character(property) do
    IO.gets("What is your character's #{property}?\n") |> String.trim()
  end
end
