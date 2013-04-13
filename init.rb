require 'debugger'
require './state'
require './square'
require './move'

s = State.new
s.initBoard

s.printBoard

puts "
a1 b1 c1 d1 e1
a2 b2 c2 d2 e2
a3 b3 c3 d3 e3
a4 b4 c4 d4 e4
a5 b5 c5 d5 e5
a6 b6 c6 d6 e6
"

puts " \nNext turn\n "

#puts s.board[1][1]
#puts s.moveList(1,2).flatten

#puts s.isPiece?(Square.new(1,2))
#debugger
s.move(Move.new(Square.new(1,1), Square.new(1,2)))
s.printBoard

s.move(Move.new(Square.new(1,2), Square.new(1,3)))
s.printBoard
