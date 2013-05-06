#/usr/bin/env ruby
require './state'
require 'debugger'

game = State.new

game.initBoard

game.printBoard

puts "bestKillbot (W) vs evalBot(B)"

while not game.gameOver? do
  game.chooseBestKill
  game.printBoard
  break if game.gameOver?
  game.evalMove
  game.printBoard
end

