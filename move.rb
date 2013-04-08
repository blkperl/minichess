class Move

  def initialize(fs, ts)
    @fromSquare = fs
    @toSquare = ts
  end

  # print moves
  def print()
    from = toChessSquare(@fromSqaure.x,@fromSqaure.y)
    to = toChessSquare(@toSquare.x, @toSquare.y)
    "#{from}-#{to}"
  end

  # convert from xy coordinates to chessboard coordinates
  def toChessSquare(x,y)
   col = ['a','b','c','d','e'][x]
   row = y+1
   col + row.to_s
  end

end
