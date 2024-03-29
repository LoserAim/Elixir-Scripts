defmodule KeyValue do
  @moduledoc """
    Purpose:
      Provides functions for inserting into and fetching from maps. A
      map that is created will be saved into a binary file for ease of
      access. When the script exits, it will delete the data.
  """
  

  @doc """
    Purpose:
      Accepts a List of Strings and checks the first indice for correct
      syntax. As long as the first indice does not equal "exit", the
      script will loop continuously by using KeyValue.CLI.main
    Returns:
      atom
  """
  def start(args) do
    case List.first(args) do
      "push" ->
        if KeyValue.is_line_valid?(args, 3),
          do: KeyValue.push(args),
          else: IO.puts("Invalid syntax")
        KeyValue.CLI.main("")
      "pop" ->
        if KeyValue.is_line_valid?(args, 2),
          do: KeyValue.pop(args),
          else: IO.puts("Invalid syntax")
        KeyValue.CLI.main("")
      "fetch" -> 
        if KeyValue.is_line_valid?(args, 2), 
          do: KeyValue.fetch_value(args), 
          else: IO.puts("Invalid syntax.")
        KeyValue.CLI.main("")
      "put" -> 
        if KeyValue.is_line_valid?(args, 3),
          do: KeyValue.put_value(args),
          else: IO.puts("Invalid syntax.")
        KeyValue.CLI.main("")
      "exit" -> 
        KeyValue.close_script
      _ -> 
        IO.puts("Unknown command. Known commands are: push, pop, put, fetch, exit")
        KeyValue.CLI.main("")
    end
  end


  def push(args) do
    key = Enum.at(args, 1)
      |> String.to_atom
    value = Enum.at(args, 2)
    KeyValue.load("key-valueList")
      |> case do
        "File does not exist!" ->
          []
            |> List.insert_at(0, {key, [value]})
            |> KeyValue.save("key-valueList")
        list ->
          List.keyfind(list, key, 0)
            |> case do
              nil ->
                List.insert_at(list, 0, {key, [value]})
                  |> KeyValue.save("key-valueList")
              {_fetched_key, fetched_list} ->
                List.keyreplace(list, key, 0, {key, [value] ++ fetched_list})
                  |> KeyValue.save("key-valueList")
            end
      end
    IO.puts("ok")
  end
  

  def pop_and_replace(tuple, list, key) do
    Tuple.to_list(tuple)
      |> Enum.at(0)
      |> case do
        nil ->
          IO.puts("value not found")
        popped_value ->
          IO.puts(popped_value)
          popped_list = Tuple.to_list(tuple)
            |> Enum.at(1)
          List.keystore(list, key, 0, {key, popped_list})
            |> KeyValue.save("key-valueList")
      end
  end


  def pop(args) do
    key = Enum.at(args, 1)
      |> String.to_atom
    KeyValue.load("key-valueList")
      |> case do
        "File does not exist!" ->
          IO.puts("value not found")
          "value not found"
        list ->
          List.keyfind(list, key, 0)
            |> case do
              nil ->
                IO.puts("value not found")
              {_fetched_key, fetched_list} ->
                List.pop_at(fetched_list, 0)
                  |> KeyValue.pop_and_replace(list, key)
                
            end
      end
  end


  @doc """
    Purpose:
      This function determines if the count of list is equal to the
      passed in variable. It will return a boolean.
    Returns:
      boolean

  ## Examples
      iex> KeyValue.is_line_valid?(["fetch", "favorite_color"], 2)
      true
  """
  def is_line_valid?(args, limit) do
    Enum.count(args) == limit
  end


  @doc """
    Purpose:
      This function will load a binary file to access the current map.
      If the binary file does not exist, the function will return a 
      string. Else, the function will try to fetch the value from the
      map using the given key.
    Returns:
      String

  ## Examples
      iex> KeyValue.put_value(["put", "favorite_color", "purple"])
      :ok
      iex> KeyValue.fetch_value(["fetch", "favorite_color"])
      "purple"
      iex> File.rm("key-valueData")
      :ok
  """
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


  @doc """
    Purpose:
      This function will load a binary file to access the current map.
      It will then update the map with a new key and value from passed
      in function arguments. If the binary file does not exist, the 
      function will create a binary file.
    Returns:
      String

  ## Examples
      iex> KeyValue.put_value(["put", "favorite_color", "purple"])
      :ok
      iex> File.rm("key-valueData")
      :ok
  """
  def put_value(args) do
    key = Enum.at(args, 1)
      |> String.to_atom
    value = Enum.at(args, 2)
    map = KeyValue.load("key-valueData")
    if map == "File does not exist!",
      do: Map.new()
        |> Map.put(key, value)
        |> KeyValue.save("key-valueData"),
    else: Map.put(map, key, value)
        |> KeyValue.save("key-valueData")
    IO.puts("ok")
  end


  @doc """
    Purpose:
      This function will output "Bye!" to the console and then exit
      the script. It will also check if the binary file the script
      created exists. If it does exist, it will delete the file.
    Returns:
      atom

  ## Examples
      iex> KeyValue.put_value(["put", "favorite_color", "purple"])
      :ok
      iex> KeyValue.close_script
      :ok
  """
  def close_script do
    IO.puts("Bye!")
    if File.exists?("key-valueData") do
      File.rm("key-valueData")
    end
    if File.exists?("key-valueList") do
      File.rm("key-valueList")
    end
    :ok
  end


  @doc """
    Purpose:
      This function will save a given object under a given filename
      as a binary file.
    Returns:
      atom
  """
  def save(object, filename) do
    binary = :erlang.term_to_binary(object)
    File.write(filename, binary)
  end


  @doc """
    Purpose:
      This function will load a binary file from a given filename and
      convert the data in to an Elixir object.
    Returns:
      atom
  """
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "File does not exist!"
    end
  end


end
