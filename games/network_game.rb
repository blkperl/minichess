#/usr/bin/env ruby
require './state'
require './client'
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
    nc.move(game.evalMove)
  end


  while not game.gameOver? do
    nc.waitForMove
    game.humanMove(nc.getOpponentMove)
    game.nextTurn
    break if game.gameOver?
    nc.move(game.evalMove)
    game.nextTurn
  end

  nc.discconect

end
