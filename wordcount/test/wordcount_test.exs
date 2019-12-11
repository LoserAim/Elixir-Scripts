defmodule WordcountTest do
  use ExUnit.Case
  doctest Wordcount

  test "greets the world" do
    assert Wordcount.hello() == :world
  end
end
