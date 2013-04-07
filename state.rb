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

  def move(m)
  end

  def moveScan(x0, y0, c, capture=true, stop_short=false)
    x = x0
    y = y0
    c = getColor(x0,y0)
    moves = nil

    while (not stop_short)
      x += dx
      y += dy
      break if not inBounds?(x,y)

      if isOccupied(@board[x0][y0])
        break if @board[x0, y0].getColor == c
        break if not capture
        short_stop = true
        validMove = Move.new(Square.new(x0,y0, Square.new(x,y)))
        moves << validMove
        break if short_stop == true
      end
    end

    moves

  end

  def getColor(x0, y0)
    if @board[x0, y0].upcase == @board[x0, y0]
      "W"
    else
      "B"
    end
  end

  def isOccupied?(value)
    value != '.'
  end

  def inBounds?(x,y)
    x < 5 && x > 0 or y < 6 and y > 0
  end

  def moveGen
    # scan board
    # generate moves for each piece
    # return list of possible moves
  end

  def moveList

    # To list the moves of a piece at x, y: 
    p = @board[x][y].upcase
    moves = nil
    case p
      when 'Q', 'K'
        (-1..1).each do |dx|
          (-1..1).each do |dy|
            if dx == 0 and dy == 0
                next
            end
            stop_short = (p == 'K')
            moves << moveScan(x, y, dx, dy, stop_short)
          end
        end
        return moves
      when 'R', 'B'
        dx = 1
        dy = 0
        stop_short = p == 'B'
        capture = p == 'R'
        (1..4).each do |i|
            moves << moveScan(x, y, dx, dy, stop_short, capture)
            dx,dy = -dy,dx
        end
        if p == 'B'
            dx = 1
            dy = 1
            stop_short = false
            capture = true 
            (1..4).each do |i|
                moves << moveScan(x, y, dx, dy, stop_short, capture) 
                dx,dy = -dy,dx
            end
        end
        return moves
      when 'K'
        dx = 1
        dy = 2
        stop_short = true 
        (1..4).each do |i|
            moves << moveScan(x, y, dx, dy, stop_short, capture) 
            dx,dy = -dy,dx
        end
        dx = -1 
        dy = 2 
        (1..4).each do |i|
            moves << moveScan(x, y, dx, dy, stop_short, capture) 
            dx,dy = -dy,dx
        end
        return moves
    when 'P'
        dir = 1
        if p is black
            dir = -1
        end
        stop_short = true 
        m = moveScan(x, y, -1, dir, stop_short)
        if m.size == 1 and m[0] == capture
            moves << m
        end
        m << moveScan(x, y, dx, dy, stop_short) 
        if m.size == 1 and m[0] == capture
            moves << m
        end
        capture = false 
        moves << moveScan(x, y, -1, dir, stop_short)
        return moves
  end

end


