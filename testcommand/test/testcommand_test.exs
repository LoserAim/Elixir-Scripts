defmodule TestcommandTest do
  use ExUnit.Case
  doctest Testcommand

  test "greets the world" do
    assert Testcommand.hello() == :world
  end
end
