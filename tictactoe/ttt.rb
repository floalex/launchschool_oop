class Board
  attr_reader :squares
  
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]
                
  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:disable Metrics/AbcSize
  
  def []=(key, marker)
    @squares[key].marker = marker
  end
  
  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end
  
  def full?
    unmarked_keys.empty?
  end
  
  def someone_won?
    !!winning_marker
  end
  
  # return winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end
  
  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
  
  private
  
  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    # alternatively: markers.uniq.size == 1
    markers.min == markers.max
  end
  
end

class Square
  INITIAL_MARKER = " "
  
  attr_accessor :marker
  
  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end
  
  def to_s
    @marker
  end
  
  def unmarked?
    marker == INITIAL_MARKER
  end
  
  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  
  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = [HUMAN_MARKER, COMPUTER_MARKER].sample
  
  attr_reader :board, :human, :computer
  
  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end
  
  def play
    clear
    display_welcome_message
    
    loop do
      display_board
      
      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end
      
      display_result
      break unless play_again?
      reset
      display_again_message
    end
    
    display_goodbye_message
  end
  
  private
  
  def display_welcome_message
    puts "Welcome to the Tic Tac Toe game!"
    puts ""
  end
  
  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe game, goodbye!"
  end
  
  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts "" 
    board.draw
    puts "" 
  end
  
  def clear_screen_and_display_board
    clear
    display_board
  end
  
  def joinor(arr, delimiter, word="or")
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.join(delimiter)
  end
  
  def human_moves
    puts "Choose a sqaure (#{joinor(board.unmarked_keys, ', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, it is not a valid choice"
    end
    
    board[square] = human.marker
  end
  
  #computer attack/defense AI
  def find_at_risk_square(line, place)
    positions = board.squares.values_at(*line).collect(&:marker)
    if positions.count(place) == 2
      board.squares.select { |k, v| line.include?(k) && v.marker == Square::INITIAL_MARKER }.keys.first
    else
      nil
    end
  end
  
  def computer_moves
    square = nil
    
    # attack first
    Board::WINNING_LINES.each do |line|
      square = find_at_risk_square(line, COMPUTER_MARKER)
      break if square
    end
    
    if !square
      # defense
      Board::WINNING_LINES.each do |line|
        square = find_at_risk_square(line, HUMAN_MARKER)
        break if square
      end
    end
    
    if !square
      square = board.unmarked_keys.sample
    end
    
    board[square] = computer.marker
  end
  
  def human_turn?
    @current_marker == HUMAN_MARKER
  end
  
  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end
  
  def display_result
    clear_screen_and_display_board
    
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie."
    end
  end
  
  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include? answer
      puts "Sorry, must be y or n"
    end
  
    answer == 'y'
  end
  
  def clear
    system 'cls' || 'clear'
  end
  
  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end
  
  def display_again_message
    puts ""
    puts "Let's play again."
    puts ""
  end
end


# we'll kick off the game like this
game = TTTGame.new
game.play