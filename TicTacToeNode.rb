require "./06_tic_tac_toe.rb"

class TicTacToeNode
  
  attr_reader :board, :next_mover_mark
  attr_accessor :prev_move_pos
  
  def initialize(board, mark)
    @board = board
    @next_mover_mark = mark
    @prev_move_pos = []
  end
  
  def children
    children = []

    3.times do |row|
      3.times do |column|
        if @board[[row, column]].nil?
          new_board = @board.dup
          new_board[[row,column]] = @next_mover_mark
          node = TicTacToeNode.new(new_board, alternate_mark(@next_mover_mark))
          node.prev_move_pos = [row, column]
          children << node
        end
      end
    end
    
    children
  end
  
  def alternate_mark(mark)
    mark == :o ? :x : :o
  end
  
  def losing_node?(player)
    return @board.winner != player if @board.won?

    return false if children.empty?

    if self.next_mover_mark == player
      children.all? do |child|
        child.losing_node?(player)
      end
    else
      children.any? do |child|
        child.losing_node?(player)
      end
    end
  end
 
  def winning_node?(player)
    return @board.winner == player if @board.won?
    return false if children.empty?

    if self.next_mover_mark == player
      children.any? do |child|
        child.winning_node?(player)
      end
    else
      children.all? do |child|
        child.winning_node?(player)
      end
    end
  end
end

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    
    possible_moves = node.children.shuffle
    
    node =  possible_moves.find { |child| child.winning_node?(mark)}
    
    return node.prev_move_pos if node
    
    node = possible_moves.find  {|child| !child.losing_node?(mark)}
    
    return node.prev_move_pos if node
    
    raise "no no-losing nodes!"
  end
end

if __FILE__ == $PROGRAM_NAME
  hp = HumanPlayer.new("Peter")
  cp = SuperComputerPlayer.new
  TicTacToe.new(cp,hp).run
end
