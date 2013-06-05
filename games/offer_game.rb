#/usr/bin/env ruby
require File.expand_path('../../lib/state.rb', __FILE__)
require File.expand_path('../../lib/client.rb', __FILE__)

class Game

  game = State.new
  nc = Client.new
  nc.login
  game.initBoard

  game.printBoard

  # make first move if true
  if nc.offerGame
    puts "First Move is mine"
    nc.move(game.negamaxMove)
    game.printBoard
  end

  while not game.gameOver? do
    nc.waitForMove
    game.humanMove(nc.getOpponentMove)
    game.printBoard
    break if game.gameOver?
    nc.move(game.negamaxMove)
    game.printBoard
  end

  nc.exit

end
