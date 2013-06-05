#/usr/bin/env ruby
require File.expand_path('../../lib/state.rb', __FILE__)
require File.expand_path('../../lib/client.rb', __FILE__)
require 'debugger'

class Game

  game = State.new
  nc = Client.new
  nc.login
  game.initBoard

  puts "Enter Game to Accept:"
  gameId = gets.chomp

  # make first move if true
  if nc.acceptGame(gameId)
    puts "First Move is mine"
    nc.move(game.negamaxMove)
  end

  while not game.gameOver? do
    nc.waitForMove
    game.humanMove(nc.getOpponentMove)
    break if game.gameOver?
    nc.move(game.negamaxMove)
  end

  nc.exit

end
