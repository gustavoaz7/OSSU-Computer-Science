# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # 2)
  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
                  rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                  [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                   [[0, 0], [0, -1], [0, 1], [0, 2]]],
                  rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                  rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                  rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                  rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
                  rotations([[-1, 0], [-1, -1], [0, 1], [0, 0], [1, 0]]), # piece 8
                  rotations([[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]]), # piece 9
                  rotations([[0, 0], [0, 1], [1, 0]])] # piece 10

  # your enhancements here
  # 2)
  def self.next_piece(board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  # 3)
  def self.cheat_piece(board)
    MyPiece.new(rotations([[0, 0]]), board)
  end
  
end

class MyBoard < Board
  # your enhancements here
  def initializa(game)
    super
    @current_block = MyPiece.next_piece(self)
    # 3)
    @cheating = false
  end

  # 1)
  def rotate180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 1)
      @current_block.move(0, 0, 1)
    end
    draw
  end

  # 2)
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..locations.length-1).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # 3)
  def is_cheating
    !@cheating
  end
  # 3)
  def cheat
    if is_cheating && score >= 100
      @score -= 100
      @cheating = true
    end
  end 
  # 3)
  def next_piece
    if @cheating
      @current_block = MyPiece.cheat_piece(self)
      @cheating = false      
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    # 1)
    @root.bind("u", proc {@board.rotate180})
    # 3)
    @root.bind("c", proc {@board.cheat})
  end

end


