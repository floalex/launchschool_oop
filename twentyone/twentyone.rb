class Player
  def initialize
    # What would the "data" or "states" of a Player object entail?
    # maybe cards? maybe name?
  end
  
  def hit
  end
  
  def stay
  end
  
  def busted?
  end
  
  def total
    #definitely looks like we need to know about cards to calculate the total
  end
end

class Dealer
  def initialize
    # seems like very similar to the player, do we still need this?
  end
  
  def deal
    # Does the dealer or the deck deal?
  end
  
  def hit
  end
  
  def stay
  end
  
  def busted?
  end
  
  def total
  end
end

class Participant
  # what goes in here? all the redundant behavious from Player and Dealer?
end

class Deck
  def initialize
    # obviously, we need some data structure to keep track of cards
    # array, hash, something else?
  end
  
  def deal
    # does the dealer or the deck deal?
  end
end

class Card
  def initialize
    # what are the states of the card?
  end
end

class Game
  def start
    # what is the sequence of the steps to execute the game?
    deal_cards
    show_initial_card
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start