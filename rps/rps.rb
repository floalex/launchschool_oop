class Player
  attr_accessor :move, :name, :score
  
  def initialize
    @move = nil
    set_name
    @score = 0
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']
  
  def initialize(value)
    @value = value
  end
  
  def rock?
    @value == 'rock'
  end
  
  def paper?
    @value == 'paper'
  end
  
  def scissors?
    @value == 'scissors'
  end
  
  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end
  
  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end
  
  def to_s
    @value
  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2)
  
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What is your name?"
      n = gets.chomp 
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end
  
  def choose
    choice = nil
    loop do 
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, please choose a valid choice"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end
  
  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  WINNING_CONDITION = 3
  attr_accessor :human, :computer
  
  def initialize
    @human = Human.new
    @computer = Computer.new
  end
  
  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors! #{human.name}"
    puts "First player to #{WINNING_CONDITION} points wins this game!"
    puts "Your competitor is #{computer.name}"
    puts "Press crtl + c to exit any time you want"
  end
  
  def display_goodbye_message
    puts "Good bye, #{human.name}! Hope you enjoy Rock, Paper, Scissors."
  end
  
  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}"
  end
  
  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
      puts "#{human.name} earned 1 point!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      computer.score += 1
      puts "#{computer.name} earned 1 point!"
    else
      puts "It's a tie!"
    end
  end
  
  def display_score
    puts "#{human.name} has score: #{human.score}"
    puts "#{computer.name} has score: #{computer.score}"
  end
  
  def winning_score
    if human.score == WINNING_CONDITION
      puts "#{human.name} has #{WINNING_CONDITION} points now! #{human.name} won!"
    elsif computer.score == WINNING_CONDITION
      puts "#{computer.name} has #{WINNING_CONDITION} points now! #{computer.name} won!"
    end
  end
  
  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?(y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must enter y or n"
    end
    
    return false if answer == 'n'
    return true if answer == 'y'
  end

  def play
    display_welcome_message
    loop do
      while human.score < WINNING_CONDITION && computer.score < WINNING_CONDITION
        human.choose
        computer.choose
        display_moves
        display_winner
        display_score
      end
      winning_score
      break unless play_again?
      human.score = 0
      computer.score = 0
    end
    display_goodbye_message
  end
end

RPSGame.new.play