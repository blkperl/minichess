require 'debugger'
require './state'

s = State.new
s.init_board

board2 = [
  ['k','.','b','.','r'],
  ['.','.','p','.','.'],
  ['.','.','.','.','.'],
  ['.','.','.','.','.'],
  ['P','P','P','P','P'],
  ['R','N','B','Q','K'],]

s.board=board2
s.print_board

puts s.board[0][0]
puts s.moveList(0,0)
