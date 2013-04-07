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
        validMove = Move.new(Square.new(x0,y0, Square.new(x,y))
        moves << validMove
        break if short_stop = true
      end
    end

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

    moveList = self.moveScan(3,1,0,1,false,true)
    moveList.each do |x|
      puts x.to_s
    end

=begin
    # To list the moves of a piece at x, y: 
    p = @board[x][y]
    moves = nil
    case p
      when queen:
      when king:
        (-1..1).each do |dx|
          (-1..1).each do |dy|
            if dx == 0 and dy == 0
                next
            end
            stop_short = (p == king)
            moves = moves.insert(moveScan(x, y, dx, dy, stop_short))
          end
        end
        return moves
      when rook:
      when bishop:
        dx = 1
        dy = 0
        stop_short = p == bishop
        capture = p == rook
        (1..4).each do |i|
            moves = moves.insert(moveScan(x, y, dx, dy, stop_short, capture)
            exchange dx with dy 
            negate dy 
        if p = bishop 
            dx ← 1 
            dy ← 1 
            stop-short ← false 
            capture ← true 
            for i in 1 .. 4 
                moves ← moves ∪ scan(x, y, dx, dy, stop-short, capture) 
                exchange dx with dy 
                negate dy 
        return moves 
    knight: 
        dx ← 1 
        dy ← 2 
        stop-short ← true 
        for i in 1 .. 4 
            moves ← moves ∪ scan(x, y, dx, dy, stop-short) 
            exchange dx with dy 
            negate dy 
        dx ← -1 
        dy ← 2 
        for i in 1 .. 4 
            moves ← moves ∪ scan(x, y, dx, dy, stop-short) 
            exchange dx with dy 
            negate dy 
        return moves 
    pawn: 
        dir ← 1 
        if p is black 
            dir ← -1 
        stop-short ← true 
        m ← scan(x, y, -1, dir, stop-short) 
        if |m| = 1 and m[0] is a capture 
            moves ← moves ∪ m 
        m ← scan(x, y, 1, dir, stop-short) 
        if |m| = 1 and m[0] is a capture 
            moves ← moves ∪ m 
        capture ← false 
        moves ← moves ∪ scan(x, y, 0, dir, stop-short, capture) 
        return moves
=end
  end

end


