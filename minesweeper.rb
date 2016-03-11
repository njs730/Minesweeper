require 'byebug'

class Tile

  def initialize(board)
    @board = board
    @bomb = false
  end

  def set_bomb
    @bomb = true
  end

  def bomb?
    @bomb
  end

end

class Board
  attr_accessor :grid
  def initialize(width, height)
    @grid = Array.new(width) do
      Array.new(height)
    end
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
        (tile.bomb?) ? (print " X ") : (print " O ")
      end
      puts ""
    end
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
  end

  def over?

  end

  def play_turn
    puts "What space do you want to check? x,y"
    input = gets.chomp.split(",").map(&:to_i)
  end

end
g = Game.new(4,5, 2)
g.set_up_bombs
