defmodule Key_value.CLI do
    def main(_args) do
        input = Key_value.CLI.get_line
        IO.inspect(input)
    end
    def get_line do
        IO.gets("> ") 
            |> String.trim 
            |> String.split(" ", trim: true)
    end
    
end