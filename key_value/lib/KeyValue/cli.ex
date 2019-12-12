defmodule KeyValue.CLI do
	@moduledoc """
		Purpose:
			Provides a function main that will get stdin and pass it to the
			KeyValue.start. Will format the data received in stdin to a
			list of strings.
	"""

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