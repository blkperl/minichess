#/usr/bin/env ruby
require './state'

game = State.new

game.initBoard

while not game.gameOver? do
  game.randomMove
  game.nextTurn
  game.printBoard
  game.randomMove
  game.nextTurn
  game.printBoard
end

