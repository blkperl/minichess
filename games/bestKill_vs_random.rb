#/usr/bin/env ruby
require './state'
require 'debugger'

game = State.new

game.initBoard

game.printBoard

puts "bestKillbot vs randomBot"

while not game.gameOver? do
  game.chooseBestKill
  game.nextTurn
  game.printBoard
  break if game.gameOver?
  game.randomMove
  game.nextTurn
  game.printBoard
end

