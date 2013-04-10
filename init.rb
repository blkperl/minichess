require 'debugger'
require './state'

s = State.new
s.init_board

board2 = [
  ['.','.','.','.','.'],
  ['.','k','P','.','.'],
  ['.','.','.','.','.'],
  ['.','.','.','.','.'],
  ['P','.','P','P','P'],
  ['R','.','B','Q','K'],]

s.board=board2
s.print_board
#s.print_board

#puts s.board[1][1]
puts s.moveList(1,1).flatten
s.print_board



