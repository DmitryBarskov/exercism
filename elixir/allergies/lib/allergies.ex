defmodule Allergies do
  import Bitwise, only: [band: 2]

  @allergy_to_bit %{
    "eggs" => 1,
    "peanuts" => 2,
    "shellfish" => 4,
    "strawberries" => 8,
    "tomatoes" => 16,
    "chocolate" => 32,
    "pollen" => 64,
    "cats" => 128
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Enum.reduce(
      @allergy_to_bit,
      [],
      fn
        {allergy, bit}, list when band(flags, bit) > 0 -> [allergy | list]
        _, acc -> acc
      end
    )
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    band(flags, @allergy_to_bit[item]) > 0
  end
end
