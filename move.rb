require './square.rb'

class Move

  attr_reader :fromSquare, :toSquare

  def initialize(fs, ts)
    @fromSquare = fs
    @toSquare = ts
  end

  # print moves
  def to_s
    from = toChessSquare(@fromSquare.x,@fromSquare.y)
    to = toChessSquare(@toSquare.x, @toSquare.y)
    return "#{from}-#{to}"
  end

  # convert from xy coordinates to chessboard coordinates
  def toChessSquare(x,y)
   row = ['a','b','c','d','e'][x]
   col = [ 6, 5, 4, 3, 2, 1][y]
   return row + col.to_s
  end
end
