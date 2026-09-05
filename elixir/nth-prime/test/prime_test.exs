defmodule PrimeTest do
  use ExUnit.Case

  # @tag :pending
  test "first prime" do
    assert Prime.nth(1) == 2
  end

  # @tag :pending
  test "second prime" do
    assert Prime.nth(2) == 3
  end

  # @tag :pending
  test "sixth prime" do
    assert Prime.nth(6) == 13
  end

  # @tag :pending
  test "100th prime" do
    assert Prime.nth(100) == 541
  end

  # @tag :pending
  @tag :slow
  test "big prime" do
    assert Prime.nth(10001) == 104_743
  end

  # @tag :pending
  test "there is no zeroth prime" do
    catch_error(Prime.nth(0))
  end

  describe "prime?" do
    # @tag :pending
    test "numbers up to 10" do
      t = true
      f = false
      assert Enum.map(1..10, &Prime.prime?/1) == [f, t, t, f, t, f, t, f, f, f]
    end

    # @tag :pending
    test "numbers up to 20" do
      t = true
      f = false
      assert Enum.map(11..20, &Prime.prime?/1) == [t, f, t, f, f, f, t, f, t, f]
    end
  end
end
