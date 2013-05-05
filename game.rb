#/usr/bin/env ruby
require './state'
require 'debugger'

class Game

  game = State.new

  game.initBoard

  game.printBoard

  while not game.gameOver? do
    game.humanTurn
    game.nextTurn
    game.printBoard
    break if game.gameOver?
    game.evalMove
    game.nextTurn
    game.printBoard
  end

end
