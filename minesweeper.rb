require 'byebug'

class Tile
  attr_accessor :face_up
  def initialize(board)
    @board = board
    @bomb = false
    @face_up = false
  end

  def set_bomb
    @bomb = true
  end

  def bomb?
    @bomb
  end

  def reveal
    @face_up = true
  end
end

class Board
  attr_accessor :grid, :bomb_found
  def initialize(width, height)
    @grid = Array.new(width) do
      Array.new(height)
    end
    @bomb_found = false
    populate
  end

  def populate
    grid.each do |row|
      row.map! do |space|
        space = Tile.new(self)
      end
    end
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, val)
    @grid[row][col] = val
  end

  def render
    grid.each do |row|
      row.each do |tile|
        if tile.face_up
          (tile.bomb?) ? (print " X ") : (print " O ")
        else
          print " _ "
        end
      end
      puts ""
    end
    puts ""
  end

  def handle_move(input)
    x,y = input
    grid[x][y].reveal
    @bomb_found = true if @grid[x][y].bomb?
  end

end

class Game
  attr_reader :board, :bomb_count
  def initialize(width, height, bomb_count)
    @board = Board.new(width, height)
    @bomb_count = bomb_count
  end

  def set_up_bombs
    i = 0
    # debugger
    while i < bomb_count
      bomb_count.times do
        row = rand(@board.grid.length)
        col = rand(@board.grid[0].length)
        tile = board.grid[row][col]
        unless tile.bomb?
          tile.set_bomb
          i += 1
        end
      end
    end
  end

  def play
    set_up_bombs
    until over?
      board.render
      play_turn
    end
    board.render
    puts "Kaboom"
  end

  def over?
    @board.bomb_found
  end

  def play_turn
    puts "What space do you want to check? x,y"
    input = gets.chomp.split(",").map(&:to_i)
    @board.handle_move(input)
  end

end
g = Game.new(4,5, 18)
g.play
