defmodule KitchenCalculator do
  def get_volume({_unit, value}), do: value

  def to_milliliter({:milliliter, ml}), do: {:milliliter, ml}
  def to_milliliter({:cup, cups}), do: {:milliliter, cups * 240}
  def to_milliliter({:fluid_ounce, ounces}), do: {:milliliter, ounces * 30}
  def to_milliliter({:teaspoon, teaspoons}), do: {:milliliter, teaspoons * 5}
  def to_milliliter({:tablespoon, tablespoons}), do: {:milliliter, tablespoons * 15}

  def from_milliliter({:milliliter, ml}, :milliliter), do: {:milliliter, ml}
  def from_milliliter({:milliliter, ml}, :cup), do: {:cup, ml / 240.0}
  def from_milliliter({:milliliter, ml}, :fluid_ounce), do: {:fluid_ounce, ml / 30.0}
  def from_milliliter({:milliliter, ml}, :teaspoon), do: {:teaspoon, ml / 5.0}
  def from_milliliter({:milliliter, ml}, :tablespoon), do: {:tablespoon, ml / 15.0}


  def convert(volume_pair, target_unit), do: volume_pair |> to_milliliter |> from_milliliter(target_unit)
end
