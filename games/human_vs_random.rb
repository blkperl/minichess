#/usr/bin/env ruby
require './state'
require 'debugger'

game = State.new

game.initBoard

game.printBoard

while not game.gameOver? do
  game.humanTurn
  game.printBoard
  break if game.gameOver?
  game.randomMove
  game.printBoard
end

