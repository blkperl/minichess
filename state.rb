require './move.rb'
require './square.rb'

class State

  attr_accessor :board

  def initializer(mn, mc)
    @maxTurns = 80
    @move_next = mn
    @move_current = mc
    @board = []
  end

  def print_board
    @board.each do |x|
      puts x.join("")
    end
  end

  def read_board
  end

  def init_board
    @board = [
      ['k','q','b','n','r'],
      ['p','p','p','p','p'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['P','P','P','P','P'],
      ['R','N','B','Q','K'],
    ]
  end

  def humanMove(move)

  end

  def move(m)
    if m.nil? and m.side?
      State.new
    else
      throw "move error"
    end
  end

  def moveScan(x0, y0, dx, dy, capture, stop_short)
    x = x0
    y = y0
    c = getColor(x0,y0)
    moves = []

    loop do
      x += dx
      y += dy
      break if not inBounds?(x,y)

      if isOccupied?(@board[y][x])
        break if getColor(x,y) == c
        break if not capture
        stop_short = true
      end

      validMove = Move.new(Square.new(x0,y0), Square.new(x,y))
      moves << validMove
      break if stop_short == true
    end

    return moves
  end

  def getColor(x, y)
    if @board[y][x].to_s.upcase == @board[y][x]
      "W"
    else
      "B"
    end
  end

  def isCapture?(fs, ts)
    if @board[ts.y][ts.x] == '.'
      return false
    else
      return @board[fs.y][fs.x].to_s != @board[ts.y][ts.x].to_s
    end
  end

  def isOccupied?(value)
    value != '.'
  end

  def inBounds?(x,y)
    x < 5 and x > -1 and y < 6 and y > -1
  end

  def moveGen
    # scan board
    # generate moves for each piece
    # return list of possible moves
  end

  def moveList(x,y)

    # To list the moves of a piece at x, y: 
    p = @board[y][x].to_s.upcase
    moves = []

    case p
      when 'Q', 'K'
        (-1..1).each do |dx|
          (-1..1).each do |dy|
            if dx == 0 and dy == 0
                next
            end
            stop_short = (p == 'K')
            moves << moveScan(x, y, dx, dy, capture=true, stop_short)
          end
        end
        return moves
      when 'R'
        dx = 1
        dy = 0
        stop_short = false
        capture = true
        for i in 1..4
          moves << moveScan(x, y, dx, dy, capture, stop_short)
          dx,dy = -dy,dx
        end
        return moves
      when 'B'
        dx = 1
        dy = 0
        stop_short = true
        capture = false
        for i in 1..4
          moves << moveScan(x, y, dx, dy, capture, stop_short)
          dx,dy = -dy,dx
        end
        #if p == 'B'
          dx = 1
          dy = 1
          stop_short = false
          capture = true
          for i in 1..4
              moves << moveScan(x, y, dx, dy, capture, stop_short)
              dx,dy = -dy,dx
          end
        #end
        return moves
      when 'N'
        dx = 1
        dy = 2
        stop_short = true
        capture = true
        for i in 1..4
            moves << moveScan(x, y, dx, dy, capture, stop_short)
            dx,dy = -dy,dx
        end
        dx = -1
        dy = 2
        for i in 1..4
            moves << moveScan(x, y, dx, dy, capture, stop_short)
            dx,dy = -dy,dx
        end
        return moves
      when 'P'

        # inverse the direction of black pawns
        dir = (getColor(x,y) == 'B') ? 1 : -1

        stop_short = true

        # West
        m = moveScan(x, y, -1, dir, true, stop_short)
        # check if I can capture diag (NW or SW)
        if m.size == 1 and isCapture?(m[0].fromSquare, m[0].toSquare)
            moves << m
        end
        # East
        m = moveScan(x, y, 1, dir, true, stop_short)
        # check if I can capture diag ( NE or SE)
        if m.size == 1 and isCapture?(m[0].fromSquare, m[0].toSquare)
            moves << m
        end
        moves << moveScan(x, y, 0, dir, false, stop_short)
        return moves
      end
    end

end


