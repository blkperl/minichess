class State

#@move_next
#@move_current
@board


  def print_board
    puts @board
  end

  def read_board
  end

  def init_board
    @board = [
      ['k''q''b''n''r'],
      ['p''p''p''p''p'],
      ['.''.''.''.''.'],
      ['.''.''.''.''.'],
      ['P''P''P''P''P'],
      ['R''N''B''Q''K'],
    ]
  end


end


