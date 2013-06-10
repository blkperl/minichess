
require File.expand_path('../square.rb', __FILE__)
require File.expand_path('../move.rb', __FILE__)
require File.expand_path('../exceptions.rb', __FILE__)

class State

  attr_accessor :board, :moveCounter

  MAXTURNS = 80
  $mzero = 'UNSET'

  def initialize
    @board = []
    @moveCounter = 1
    @sideOnMove = 'W'
    @nodes = 0
  end

  def printBoard
    puts "#{@moveCounter} #{@sideOnMove}"
    @board.each do |x|
      puts x.join("")
    end
    puts "\n"
  end

  def initBoard
    @board = [
      ['k','q','b','n','r'],
      ['p','p','p','p','p'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['P','P','P','P','P'],
      ['R','N','B','Q','K'],
    ]
  end

  def gameOver?(board=@board, moveCounter=@moveCounter)
    if not board.flatten.include?('k')
      #puts "white wins"
      return true
    elsif not board.flatten.include?('K')
      #puts "black wins"
      return true
    elsif moveCounter > MAXTURNS
      puts "draw"
      return true
    else
      return false
    end
  end

  def timeRemains?
    if Time.now - @turnTimer > 3
      return false
    else
      return true
    end
  end

  def captureKing?(move, board, sideOnMove)
    piece = board[move.toSquare.y][move.toSquare.x]
    if piece == 'k' and sideOnMove == 'W'
      return true
    elsif piece == 'K' and sideOnMove == 'B'
      return true
    else
      return false
    end
  end

  def bestMove(board=@board, sideOnMove=@sideOnMove)
    @turnTimer = Time.now
    @nodes = 0
    d0 = 1
    m0 = 'UNSET'
    negaScore = 0
    values = {}

    getLegalMoves(board, sideOnMove).each do |move|
      copyOfBoard = Marshal.load( Marshal.dump(board) )
      if captureKing?(move, copyOfBoard, sideOnMove)
        return move
      end
      move(move, copyOfBoard, sideOnMove)
      values[move] = improvedScoreGen(copyOfBoard, sideOnMove)
    end

    while timeRemains?
      v = -10000000
      a0 = -1.0

      # shuffle values
      sortedValues = values.to_a
      sortedValues.shuffle!
      # sort from greatest to least
      sortedValues = sortedValues.sort_by { | m, v | v }.reverse
      # run negamax from greatest to least
      sortedValues.each { |tuple|
        copyOfBoard = Marshal.load( Marshal.dump(board) )
        move(tuple.first, copyOfBoard, sideOnMove)
        v0 = [v, -negamax(copyOfBoard, d0, sideOnMove, -1.0, -a0)].max
        a0 = [a0, v0].max
        if v0 > v
         m0 = tuple.first
         negaScore = v0
        end

        v = [v, v0].max
      }

      d0 = d0 + 1
      puts "depth is #{d0}"
    end

    puts "Negamax at (#{@nodes}), move is #{m0}, score is #{negaScore}, time is #{Time.now - @turnTimer}"
    turnMove(m0)
    return m0
  end

  def negamax(board, depth, sideOnMove, alpha, beta)
      if gameOver?(board) or depth == 0
        return improvedScoreGen(board, sideOnMove)
      end

      @nodes += 1
      # gather all the moves
      values = {}

      getLegalMoves(board, sideOnMove).each do |move|
        copyOfBoard = Marshal.load( Marshal.dump(board) )
        move(move, copyOfBoard, sideOnMove)
        values[move] = improvedScoreGen(copyOfBoard, sideOnMove)
      end

      v = -1.0
      alpha0 = alpha

      # switch sides
      sideOnMove == 'W' ? sideOnMove = 'B' : sideOnMove = 'W'
      # sort from greatest to least
      sortedValues = values.sort_by { |move, value| value}.reverse
      # run negamax from greatest to least
      sortedValues.each { |tuple|
        copyOfBoard = Marshal.load( Marshal.dump(board) )
        move(tuple.first, copyOfBoard, @sideOnMove)
        v = [v, -negamax(copyOfBoard, depth - 1, sideOnMove, -beta, -alpha0)].max
        alpha0 = [alpha0, v].max
        if v >= beta
          return v
        end
      }
    return v
  end

  def scoreGen(copyOfBoard, sideOnMove)
    whiteScore = 0
    blackScore = 0
    getPiecesForSide(copyOfBoard, 'W').each do |piece|
      piece = copyOfBoard[piece.y][piece.x]
      whiteScore += getPieceValue(piece)
    end
    getPiecesForSide(copyOfBoard, 'B').each do |piece|
      piece = copyOfBoard[piece.y][piece.x]
      blackScore += getPieceValue(piece)
    end

    score = whiteScore + blackScore
    return sideOnMove == 'W' ?  score : -score
  end

  def improvedScoreGen(copyOfBoard, sideOnMove)
    whiteScore = 0
    blackScore = 0
    for y in 0..5 do
      for x in 0..4 do
        piece = Square.new(x,y)
        if isPiece?(board, piece)
          pieceColor = getColor(board, x, y)
          if pieceColor == 'W'
            piece = copyOfBoard[piece.y][piece.x]
            if piece == 'P'
              whiteScore += checkPawns(board, sideOnMove, x, y)
            end
            whiteScore += getPieceValue(piece)
          else
            piece = copyOfBoard[piece.y][piece.x]
            if piece == 'p'
              blackScore += checkPawns(board, sideOnMove, x, y)
            end
            blackScore += getPieceValue(piece)
          end
        end
      end
    end
    score = whiteScore + blackScore
    return sideOnMove == 'W' ?  score : -score
  end

  def checkPawns(board, sideOnMove, x, y)
    score = 0
    sideOnMove == 'W' ? pos = [ 5, 4, 3, 2 ] : pos = [ 3, 2, 1, 0 ]

    # additional points for moving pawns forward
    if pos.include?(y)
      score += 5
    end

    # check pawn diags
    score += checkPawnDiags(board, sideOnMove, x, y)

    return score
  end

  def checkPawnDiags(board, sideOnMove, x, y)
    score = 0
    sideOnMove == 'W' ? direction = 1 : direction = -1
    sideOnMove == 'W' ? color = 'W' : color = 'B'

    west = board[y+direction][x+1]
    east = board[y+direction][x-1]

    if not west.nil? and color == getColor(board, x, y) and  isOccupied?(west)
      score += 6
    end
    if not east.nil? and color == getColor(board, x, y) and isOccupied?(east)
      score += 6
    end

    return score
  end


  def getPieceValue(p)
    case p.upcase
      when 'P'
        score = 100
      when 'B', 'N'
        score = 300
      when 'R'
        score = 500
      when 'Q'
        score = 900
      when 'K'
        score = 10000
      when  '.'
        score = 0
    end

    return p.upcase == p ? score : - score
    #return score
  end

  def getPiecesForSide(board, color)
    pieces = []
    for y in 0..5 do
      for x in 0..4 do
        piece = Square.new(x,y)
        if isPiece?(board, piece) and color == getColor(board, x, y)
           pieces << piece
        end
      end
    end
    return pieces
  end

  def humanTurn
    puts "Enter Move:"
    input = gets.strip
    begin
      humanMove(input)
    rescue InvalidHumanMove
      puts "Invalid move #{input}, Please try again"
      humanTurn
    end
  end

  def humanMove(hmove)
    begin
      m = hmove.split("-")
      fs = getChessSquare(m.first)
      ts = getChessSquare(m.last)
      hmove = Move.new(fs, ts)
      turnMove(hmove)
    rescue InvalidMove
      raise InvalidHumanMove, hmove.to_s
    rescue InvalidSquare
      raise InvalidHumanMove, hmove.to_s
    end
  end

  def turnMove(move)
      move(move, @board, @sideOnMove)
      @moveCounter += 1
      @sideOnMove == 'W' ? @sideOnMove = 'B' : @sideOnMove = 'W'
  end

  def move(m, board, sideOnMove)
    begin
      if isPiece?(board, m.fromSquare) and (getColor(board, m.fromSquare.x, m.fromSquare.y) == sideOnMove)

        moves = []
        moveList(m.fromSquare.x, m.fromSquare.y, board).flatten.each do |m| 
          moves << m.to_s 
        end

        if not moves.include?(m.to_s)
          raise InvalidMove, "Error: Not a valid move x, y is fromSquare: #{m.fromSquare.x} #{m.fromSquare.y}, toSquare is #{m.toSquare.x} #{m.toSquare.y}"
        else
          updateBoard(m, board)
        end
      end
    rescue InvalidPiece => e
        raise InvalidMove, e.message
    end
  end

  def updateBoard(m, board)
    # move piece to toSquare
    board[m.toSquare.y][m.toSquare.x] = board[m.fromSquare.y][m.fromSquare.x]
    # set from square to empty
    board[m.fromSquare.y][m.fromSquare.x] = '.'

    # if piece is pawn and reaches the end of the board, then its becomes a queen
    if board[m.toSquare.y][m.toSquare.x].upcase == 'P'
      if m.toSquare.y == 5 and getColor(board, m.toSquare.x, m.toSquare.y) == 'B'
        board[m.toSquare.y][m.toSquare.x] = 'q'
      end
      if m.toSquare.y == 0 and getColor(board, m.toSquare.x, m.toSquare.y) == 'W'
        board[m.toSquare.y][m.toSquare.x] = 'Q'
      end
    end

  end

  def moveScan(x0, y0, dx, dy, capture, stop_short, board)
    x = x0
    y = y0
    c = getColor(board, x0,y0)
    moves = []

    loop do
      x += dx
      y += dy
      break if not inBounds?(x,y)

      if isOccupied?(board[y][x])
        break if getColor(board, x,y) == c
        break if not capture
        stop_short = true
      end

      validMove = Move.new(Square.new(x0,y0), Square.new(x,y))
      moves << validMove
      break if stop_short == true
    end

    return moves
  end

  def getLegalMoves(board, color)
    moves = []
    getPiecesForSide(board, color).each do |piece|
      moves << moveList(piece.x, piece.y, board).flatten
    end
    return moves.flatten
  end

  def getColor(board, x, y)
    if board[y][x].to_s.upcase == board[y][x]
      return "W"
    else
      return "B"
    end
  end

  def isPiece?(board, square)
    return ['Q','K','R','N','B','P'].include?(board[square.y][square.x].upcase)
  end

  def isCapture?(fs, ts, board)
    if board[ts.y][ts.x] == '.'
      return false
    else
      return board[fs.y][fs.x].to_s != board[ts.y][ts.x].to_s
    end
  end

  def isOccupied?(value)
    return value != '.'
  end

  def inBounds?(x,y)
    return (x < 5 and x > -1 and y < 6 and y > -1)
  end

  def moveList(x,y, board)

    # To list the moves of a piece at x, y: 
    p = board[y][x]
    moves = []

    case p
      when 'Q', 'K', 'q', 'k'
        (-1..1).each do |dx|
          (-1..1).each do |dy|
            if dx == 0 and dy == 0
                next
            end
            stop_short = (p == 'K' or p == 'k')
            moves << moveScan(x, y, dx, dy, capture=true, stop_short, board)
          end
        end
        return moves
      when 'R', 'r'
        dx = 1
        dy = 0
        stop_short = false
        capture = true
        for i in 1..4
          moves << moveScan(x, y, dx, dy, capture, stop_short, board)
          dx,dy = -dy,dx
        end
        return moves
      when 'B', 'b'
        dx = 1
        dy = 0
        stop_short = true
        capture = false
        for i in 1..4
          moves << moveScan(x, y, dx, dy, capture, stop_short, board)
          dx,dy = -dy,dx
        end
        dx = 1
        dy = 1
        stop_short = false
        capture = true
        for i in 1..4
            moves << moveScan(x, y, dx, dy, capture, stop_short, board)
            dx,dy = -dy,dx
        end
        return moves
      when 'N', 'n'
        dx = 1
        dy = 2
        stop_short = true
        capture = true
        for i in 1..4
            moves << moveScan(x, y, dx, dy, capture, stop_short, board)
            dx,dy = -dy,dx
        end
        dx = -1
        dy = 2
        for i in 1..4
            moves << moveScan(x, y, dx, dy, capture, stop_short, board)
            dx,dy = -dy,dx
        end
        return moves
      when 'P', 'p'

        # inverse the direction of black pawns
        dir = (getColor(board, x,y) == 'B') ? 1 : -1

        stop_short = true

        # West
        m = moveScan(x, y, -1, dir, true, stop_short, board)
        # check if I can capture diag (NW or SW)
        if m.size == 1 and isCapture?(m[0].fromSquare, m[0].toSquare, board)
            moves << m
        end
        # East
        m = moveScan(x, y, 1, dir, true, stop_short, board)
        # check if I can capture diag ( NE or SE)
        if m.size == 1 and isCapture?(m[0].fromSquare, m[0].toSquare, board)
            moves << m
        end
        moves << moveScan(x, y, 0, dir, false, stop_short, board)
        return moves

      else
        raise InvalidPiece, "Error: moveList called on invalid piece '#{p}' with coordinates x: #{x} y: #{y}"
      end
    end

  def getChessSquare(square)
    row = ['a','b','c','d','e']
    x = row.index(square[0].chr)
    y = [6, 5, 4, 3, 2, 1, 0][square[1].chr.to_i]
    return Square.new(x,y)
  end
end


