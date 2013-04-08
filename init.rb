require 'debugger'
require './state'

s = State.new
s.init_board
s.print_board

puts s.board[1][0]

s.moveList('K',1,0)
