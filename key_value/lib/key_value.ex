defmodule KeyValue do
  
  def start(args) do
    case List.first(args) do
      "fetch" -> 
        KeyValue.parse_line(args, 2)
        KeyValue.fetch_value(args)
      "put" -> 
        KeyValue.parse_line(args, 3)
        KeyValue.put_value(args)
      "exit" -> 
        KeyValue.close_script
      _ -> 
        IO.puts("Unknown command. Known commands are: put, fetch, exit")
    end
    KeyValue.CLI.main("")
  end

  def parse_line(args, limit) do
    if Enum.count(args) != limit do
      IO.puts("Invalid syntax.")
      KeyValue.CLI.main("")
    else
      true
    end
  end

  def fetch_value(args) do
    key = Enum.at(args, 1)
      |> String.to_atom
    map = KeyValue.load("key-valueData")
    if map == "File does not exist!" do
      IO.puts("value not found")
      "value not found"
    else
      case  Map.fetch(map, key) do
        {:ok, value} -> 
          IO.puts(value)
          value
        _ -> 
          IO.puts("value not found")
          "value not found"
      end
    end
    
    
  end

  def put_value(args) do
    key = Enum.at(args, 1)
      |> String.to_atom
    value = Enum.at(args, 2)
    map = KeyValue.load("key-valueData")
    if map == "File does not exist!" do
      Map.new()
      |> Map.put(key, value)
      |> KeyValue.save("key-valueData")
    else
      Map.put(map, key, value)
      |> KeyValue.save("key-valueData")
    end
    IO.puts("ok")

  end

  def close_script do
    IO.puts("Bye!")
    if File.exists?("key-valueData") do
      File.rm("key-valueData")
    end
    System.halt(0)
  end

  def save(object, filename) do
    binary = :erlang.term_to_binary(object)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "File does not exist!"
    end
  end


end
