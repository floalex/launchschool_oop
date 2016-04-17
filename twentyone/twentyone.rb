class Card
  SUITS = ['H', 'D', 'S', 'C']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(suit, value)
    @suit = suit
    @value = value
  end
  
  def to_s
    "The #{value} of #{suit}"
  end
  
  def value
    case @value
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @value
    end
  end
  
  def suit
    case @suit
    when 'H' then 'Heart'
    when 'D' then 'Diamond'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end
  
  def ace?
    value == 'Ace'
  end
end

class Deck
  attr_accessor :cards
  
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
    
    cards_mix!
  end
  
  def cards_mix!
    cards.shuffle!
  end
  
  def deal_one
    cards.pop
  end
end

module Hand
  def add_card(new_card)
    cards << new_card
  end
  
  def show_hand
    puts "--- #{name} Hands ---"
    cards.each { |card| puts "=> #{card}"}
    puts "=> #{name}'s total: #{total}"
    puts ""
  end
  
  def total
    # cards = [['H', '3'], ['S', 'Q'], ... ]
    sum = 0
    cards.each do |card|
      if card.ace?
        sum += 11
      elsif card.value.to_i == 0 #J, Q, K
        sum += 10
      else
        sum += card.value.to_i
      end
    end
    
    # correct the ace value
    cards.select(&:ace?).count.times do 
      break if sum < 21
      sum -= 10
    end
    
    sum
  end
  
  def busted?
    total > 21
  end
end

class Participant
  include Hand
  
  attr_accessor :name, :cards
  
  def initialize
    set_name
    @cards = []
  end
end

class Player < Participant
  def set_name
    name = nil
    loop do
      puts "What is your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, please enter a valid name"
    end
    self.name = name
  end
  
  def show_initial_card
    show_hand
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']
  
  def set_name
    self.name = ROBOTS.sample
  end
  
  def show_initial_card
    puts "--- Dealer #{name}'s Hand ---"
    puts "=> #{cards[0]}"
    puts "=> ??"
    puts ""
  end
end

class TwentyOne
  attr_accessor :deck, :player, :dealer
  
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end
  
  def start
    display_welcome_message
    
    loop do
      deal_cards
      show_initial_card
      
      player_turn
      if player.busted?
        show_busted
        if play_again?
          reset
          next
        else
          break
        end
      end
      
      dealer_turn
      if dealer.busted?
        show_busted
        if play_again?
          reset
          next
        else
          break
        end
      end
      
      #both stay
      show_cards
      show_result
      play_again? ? reset : break

    end
    
    display_goodbye_message
  end
  
  def display_welcome_message
    puts "Welcome to the Twenty One game!"
    puts ""
  end
  
  def deal_cards
    2.times do 
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end
  
  def show_initial_card
    player.show_initial_card
    dealer.show_initial_card
  end
  
  def player_turn
    puts "#{player.name}'s turn..."
    
    loop do
      answer = nil
      loop do
        puts "Would you like to (h)it or (s)tay?"
        answer = gets.chomp.downcase
        break if %(h s).include?(answer)
        puts "Sorry, must enter 'h' or 's'"
      end
      
      if answer == 's'
        puts "#{player.name} stays!"
        break
      elsif player.busted?
        break
      else
        puts "#{player.name} hits!"
        player.add_card(deck.deal_one)
        player.show_hand
        break if player.busted?
      end
    end
  end
  
  def dealer_turn
    puts "#{dealer.name}'s turn..."
    
    loop do
      if dealer.total >= 17 && !dealer.busted?
        puts "#{dealer.name} stays!"
        break
      elsif dealer.busted?
        break
      else
        puts "#{dealer.name} hits!"
        dealer.add_card(deck.deal_one)
      end
    end
  end
  
  def show_busted
    if player.busted?
      puts "It looks like #{player.name} busted, dealer wins!"
    elsif dealer.busted?
      puts "It looks like dealer busted, #{player.name} wins!"
    end
  end
  
  def play_again?
    answer = nil
    loop do
      puts "Would you want to play again?(y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer)
      puts "Sorry, must enter 'y' or 'n'"
    end
    
    answer == 'y'
  end
  
  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end
  
  def show_cards
    player.show_hand
    dealer.show_hand
  end
  
  def show_result
    if player.total > dealer.total
      puts "#{player.name} wins!"
    elsif player.total < dealer.total
      puts "Dealer wins!"
    else
      puts "It's a tie!"
    end
  end
  
  def display_goodbye_message
    puts "Thank you for playing, good bye!"
  end
end

game = TwentyOne.new
game.start