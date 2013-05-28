#!/usr/bin/ruby1.9.3

require './state'
#require 'debugger'

class Game

  game = State.new

  game.initBoard

  game.printBoard

  while not game.gameOver? do
    game.humanTurn
    game.printBoard
    break if game.gameOver?
    game.negamaxMove
    game.printBoard
  end

end
