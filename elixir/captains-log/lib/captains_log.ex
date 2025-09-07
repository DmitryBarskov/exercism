defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    # io_lib.bformat("NCC-~B", ...) won't work on Exercism,
    # so use combination of to_string and :io_lib.format
    to_string(:io_lib.format("NCC-~B", [Enum.random(1000..1999)]))
  end

  def random_stardate() do
    41000.0 + :rand.uniform() * 1000
  end

  def format_stardate(stardate) do
    # :io_lib.bformat("~.1f", [stardate]) <- won't work on Exercism
    to_string(:io_lib.format("~.1f", [stardate]))
  end
end
