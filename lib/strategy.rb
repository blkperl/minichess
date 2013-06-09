
  def randomMove
    # ask each piece for valid moves
    moves = getLegalMoves(@board, $sideOnMove)
    randomMove = moves[rand(moves.size)]
    turnMove(randomMove)
    return randomMove
  end

  def evalMove
    allValidMoves = []
    getPiecesForSide(@board, $sideOnMove).each do |piece|
      allValidMoves << moveList(piece.x, piece.y, @board).flatten
    end

    m = {}
    allValidMoves.flatten.each do |move|
      piece = @board[move.toSquare.y][move.toSquare.x]
      # FIXME: make king worth more
      if piece.upcase == 'K'
        self.turnMove(move)
        return move
      end
      copyOfBoard = Marshal.load( Marshal.dump(@board) )
      score = scoreGen(copyOfBoard)
      m[move] = score
    end

     if $sideOMove == 'W'
      bestMove = m.max_by { |move,val| val }.first
     else
      bestMove = m.min_by { |move,val| val }.first
     end

     turnMove(bestMove)
     puts "Eval Move chose #{bestMove}"
     return bestMove.to_s
  end

  # Not part of homework just strategy for comparision
  def chooseBestKill
    allValidMoves = []
    getPiecesForSide(@board, $sideOnMove).each do |piece|
      allValidMoves << moveList(piece.x, piece.y).flatten
    end

    m = {}
    allValidMoves.flatten.each do |move|
      piece = @board[move.toSquare.y][move.toSquare.x]
      if piece.upcase == 'K'
        self.move(move, @board)
        return move
      end
      m[move] = getPieceValue(piece.upcase)
    end

     bestMove = m.max_by { |move,val| val }.first
     turnMove(bestMove)
     return bestMove
  end
