defmodule NametestTest do
  use ExUnit.Case
  doctest Nametest

  test "greets the world" do
    assert Nametest.hello() == :world
  end
end
