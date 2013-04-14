#/usr/bin/env ruby
require './state'

game = State.new

game.initBoard

while not game.gameOver? do
  game.randomMove
  game.nextTurn
  game.printBoard
  break if game.gameOver?
  game.randomMove
  game.nextTurn
  game.printBoard
end

