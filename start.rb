#!/usr/bin/env ruby

require './state'
require 'debugger'

class Game

  game = State.new

  game.initBoard

  game.printBoard

  while not game.gameOver? do
    game.negamaxMove
    game.printBoard
    break if game.gameOver?
    game.humanTurn
    game.printBoard
  end

end
