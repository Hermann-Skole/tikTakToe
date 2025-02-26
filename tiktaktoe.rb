class Board
  def initialize
    @board = Array.new(3) { Array.new(3, ' ') }
  end

  def display
    @board.each do |row|
      puts row.join(' | ')
      puts '---------'
    end
  end

  def place_symbol(row, col, symbol)
    if row.between?(0, 2) && col.between?(0, 2) && @board[row][col] == ' '
      @board[row][col] = symbol
      true
    else
      false
    end
  end

  def check_win(symbol)
    3.times do |i|
      return true if @board[i].all? { |cell| cell == symbol }
      return true if @board.all? { |row| row[i] == symbol }
    end

    return true if @board[0][2] == symbol && @board[1][1] == symbol && @board[2][0] == symbol
    return true if @board[0][0] == symbol && @board[1][1] == symbol && @board[2][2] == symbol

    false
  end

  def full?
    @board.flatten.none? { |cell| cell == ' ' }
  end
end

class Player
  attr_reader :name, :symbol

  def initialize(taken_symbols = nil)
    puts("Enter your name")
    @name = gets.chomp
    loop do
      puts("Enter your symbol (X or O)")
      @symbol = gets.chomp.upcase
      break if (@symbol == 'X' || @symbol == 'O') && taken_symbols != @symbol

      puts("Invalid symbol, please enter X or O, it might already be taken")
    end
  end

  def make_move(board)
    loop do
      puts "#{name}, enter your move (row and column) separated by a space (1-3 for both):"
      row, col = gets.chomp.split.map(&:to_i)
      row -= 1
      col -= 1
      if row.between?(0, 2) && col.between?(0, 2)
        if board.place_symbol(row, col, symbol)
          break
        else
          puts "Invalid move, the cell is already taken. Try again."
        end
      else
        puts "Invalid input, please enter numbers between 1 and 3."
      end
    end
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new
    @player2 = Player.new(@player1.symbol)
    @current_player = @player1
  end

  def start_game
    loop do
      @board.display
      @current_player.make_move(@board)

      if check_winner
        @board.display
        puts "#{@current_player.name} wins!"
        break
      elsif @board.full?
        @board.display
        puts "It's a draw!"
        break
      end

      switch_player
    end
  end

  def switch_player
    @current_player = @player1 == @current_player ? @player2 : @player1
  end

  def check_winner
    @board.check_win(@current_player.symbol)
  end
end

game1 = Game.new
game1.start_game