
# stream = Stream.unfold(1, fn x -> 
#   if x != 0 do
#   else
#     IO.puts "Bye!"
#     nil
#   end 
# end)

# Stream.run(stream)

defmodule Command do
    def main(args) do
        {parsed, args, invalid} = OptionParser.parse(
            args,
            switches: [fetch: nil, put: nil, exit: nil],
            aliases: [f: :fetch, p: :put, e: :exit])
        IO.inspect {parsed, args, invalid}
    end
end
defmodule Looper do
  def say_hello(times_left) do
    case times_left do
      0 ->
        :ok
        System.halt(0)
      x ->
        input = IO.gets("") |> String.trim
        
        args = String.split(input, " ", trim: true)
        Command.main(args)
        for arg <- args do
            if arg == "exit" do
                say_hello(x-1)
            else
                IO.inspect(arg)
            end
        end
        say_hello(x)
    end
  end
end

Looper.say_hello(1)