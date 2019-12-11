defmodule KeyValue.CLI do
    def main(_args) do
        KeyValue.CLI.get_line
            |> KeyValue.start
    end
    def get_line do
        IO.gets("> ") 
            |> String.trim 
            |> String.split(" ", trim: true)
    end    
end