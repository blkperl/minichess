require './move.rb'
require './square.rb'

class State

  attr_accessor :board

  MAXTURNS = 80
  $moveCounter = 0

  def initializer()
    @move_next
    @move_current
    @board = []
  end

  def print_board
    @board.each do |x|
      puts x.join(" ")
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

  def gameOver?
    if not @board.flatten.include?('k')
      puts "black wins"
      return true
    elsif not @board.flatten.include?('K')
      puts "white wins"
      return true
    elsif @movesCounter == MAXTURNS
      puts "draw"
      return true
    else
      return false
    end
  end


  def randomMove
    # ask each piece for valid moves
    # call movelist
    # randomly choose a move
    # call move method
  end

#Add another method "humanMove" that takes an argument of the form "a1-b2"; that is, a pair of board coordinates with a dash between them. (Use lowercase only.) The method decodes the coordinates, checks to see if the move is fully legal, and then invokes "move" to move the piece. Otherwise, it should throw an exception. The easy way to check for a legal move is to use "move" to generate all legal moves and then walk them all.

  def humanMove(move)
    throw "nil human move error" if move.nil?

  end

  def move(m)

    sideOnMove = 'B'
    if isPiece?(m.fromSquare) and (getColor(m.fromSquare.x, m.fromSquare.y) == sideOnMove)

      puts "Move is #{m.to_s}"

      moves = []
      moveList(m.fromSquare.x, m.fromSquare.y).flatten.each do |m| 
        moves << m.to_s 
      end

      if not moves.include?(m.to_s)
        throw "Error: Not a valid move x, y is fromSquare: #{m.fromSquare.x} #{m.fromSquare.y}, toSquare is #{m.toSquare.x} #{m.toSquare.y}"
      else
        updateBoard(m)
      end

      $moveCounter += 1
    else
      throw "move error"
    end
  end

  def updateBoard(m)
    # move piece to toSquare
    @board[m.toSquare.y][m.toSquare.x] = @board[m.fromSquare.y][m.fromSquare.x]
    # set from square to empty
    @board[m.fromSquare.y][m.fromSquare.x] = '.'

    # if piece is pawn and reaches the end of the board, then its becomes a queen
    if @board[m.toSquare.y][m.toSquare.x].upcase == 'P'
      if m.toSquare.y == 5 and getColor(m.toSquare.x, m.toSquare.y) == 'B'
        @board[m.toSquare.y][m.toSquare.x] = 'q'
      end
      if m.toSquare.y == 0 and getColor(m.toSquare.x, m.toSquare.y) == 'W'
        @board[m.toSquare.y][m.toSquare.x] = 'Q'
      end
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
      return "W"
    else
      return "B"
    end
  end

  def isPiece?(square)
    return ['Q','K','R','N','B','P'].include?(@board[square.y][square.x].upcase)
  end

  def isCapture?(fs, ts)
    if @board[ts.y][ts.x] == '.'
      return false
    else
      return @board[fs.y][fs.x].to_s != @board[ts.y][ts.x].to_s
    end
  end

  def isOccupied?(value)
    return value != '.'
  end

  def inBounds?(x,y)
    return x < 5 and x > -1 and y < 6 and y > -1
  end

  def moveGen
    # scan board
    # generate moves for each piece
    # return list of possible moves
  end

  def moveList(x,y)

    # To list the moves of a piece at x, y: 
    p = @board[y][x]
    moves = []

    case p.to_s.upcase
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

      else
        throw "Error: moveList called on invalid piece '#{p}' with coordinates x: #{x} y: #{y}"
      end
    end

end


