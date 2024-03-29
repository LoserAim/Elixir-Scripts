defmodule Cards do


  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
    for value <- values, suit <- suits do
      "#{value} of #{suit}"
    end
  end
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  
  @doc """
    Determines whether a given card is inside a deck

  ## Example

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true


  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term binary
      {:error, _reason} -> "File does not exist!"
    end
  end
  def create_hand(hand_size) do
    Cards.create_deck |> Cards.shuffle |> Cards.deal(hand_size)
  end
end
