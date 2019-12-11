defmodule KeyValueTest do
  use ExUnit.Case
  doctest KeyValue

  test "KeyValue.save_file_success" do
    assert KeyValue.save("test","testfile") == :ok
    File.rm("testfile")
  end

  test "load_file_success" do
    binary = :erlang.term_to_binary("test")
    File.write("testfile", binary)
    assert KeyValue.load("testfile") == "test"
    File.rm("testfile")
  end

  test "KeyValue.load will test for fail condition" do
    binary = :erlang.term_to_binary("test")
    File.write("testfile", binary)
    assert KeyValue.load("testfile2") == "File does not exist!"
    File.rm("testfile")
  end

  test "KeyValue.parse_line determines if there are two args in given list" do
    assert KeyValue.parse_line(["testarg1", "testarg2"], 2) == true
  end

  test "KeyValue.put_value passes without failing" do
    assert KeyValue.put_value(["put", "testarg1", "testarg2"]) == :ok
    File.rm("key-valueData")
  end

  test "KeyValue.put_value save map to file" do
    KeyValue.put_value(["put", "testarg1", "testarg2"])
    {:ok, value} = KeyValue.load("key-valueData")
      |> Map.fetch(:testarg1)
    assert value == "testarg2"
    File.rm("key-valueData")
  end

  test "KeyValue.put_value rewrites value when the same key exists in map" do
    KeyValue.put_value(["put", "testarg1", "testarg2"])
    KeyValue.put_value(["put", "testarg1", "testarg3"])
    {:ok, value} = KeyValue.load("key-valueData")
      |> Map.fetch(:testarg1)
    assert value == "testarg3"
    File.rm("key-valueData")
  end

  test "KeyValue.fetch_value fetches the correct value from map with given key" do
    binary = Map.new()
      |> Map.put(:testarg1, "testarg2")
      |> :erlang.term_to_binary
    File.write("key-valueData", binary)
    assert KeyValue.fetch_value(["fetch", "testarg1"]) == "testarg2"
    File.rm("key-valueData")
  end

  test "KeyValue.fetch_value returns correctly when key does not exist in map" do
    binary = Map.new()
      |> Map.put(:testarg1, "testarg2")
      |> :erlang.term_to_binary
    File.write("key-valueData", binary)
    assert KeyValue.fetch_value(["fetch", "testarg3"]) == "value not found"
    File.rm("key-valueData")
  end

  test "KeyValue.fetch_value returns correctly when file does not exist" do
    assert KeyValue.fetch_value(["fetch", "testarg3"]) == "value not found"
  end

end
