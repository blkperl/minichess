require 'debugger'
require './state'

s = State.new
s.init_board

board2 = [
  ['.','.','.','.','r'],
  ['.','k','.','.','.'],
  ['.','.','.','.','.'],
  ['.','.','.','.','.'],
  ['P','P','P','P','P'],
  ['R','N','B','Q','K'],]

s.board=board2
s.print_board

puts s.board[1][1]
#debugger
puts s.moveList(1,1).flatten
