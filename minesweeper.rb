require 'byebug'

class Tile
  attr_accessor :face_up, :flag, :row, :col, :value
  def initialize(board,row,col)
    @board = board
    @bomb = false
    @face_up = false
    @flag = false
    @row = row
    @col = col
    @value = 0
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

  def neighbors
    (-1..1).to_a.each do |row_offset|
      (-1..1).to_a.each do |col_offset|
        next if row_offset == 0 && col_offset == 0
        new_row = @row + row_offset
        new_col = @col + col_offset
        next if new_row < 0 || new_row > @board.grid.length-1
        next if new_col < 0 || new_col > @board.grid[0].length-1
        tile = @board.grid[new_row][new_col]
        if tile.bomb?
          @value += 1
        end
      end
    end
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
    grid.each_with_index do |row, i|
      row.map!.with_index do |space, j|
        space = Tile.new(self,i,j)
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
        if tile.flag
          print " F "
        elsif tile.face_up
          (tile.bomb?) ? (print " X ") : (print " #{tile.value} ")
        else
          print " _ "
        end
      end
      puts ""
    end
    puts ""
  end

  def handle_move(input,flag)
    x,y = input
    tile = grid[x][y]
    if flag
      tile.flag = !tile.flag
    else
      unless tile.flag
        tile.reveal
        @bomb_found = true if @grid[x][y].bomb?
      end
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

  def set_up_neighbors
    board.grid.each do |row|
      row.each do |tile|
        tile.neighbors
      end
    end
  end

  def play
    set_up_bombs
    set_up_neighbors
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
    flag = false
    puts "What space do you want to check? x,y or f to flag"
    input = gets.chomp
    if input == "f"
      puts "What space do you want to flag? x,y"
      input = gets.chomp
      flag = true
    end
    input = input.split(",").map(&:to_i)
    @board.handle_move(input,flag)
  end

end
g = Game.new(4,5, 5)
g.play
