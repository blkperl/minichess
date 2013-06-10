
require File.expand_path('../../lib/state.rb', __FILE__)


describe State, "capture king" do

  state = State.new

  whitewins= [
      ['k','.','.','.','.'],
      ['.','.','.','.','.'],
      ['.','.','.','P','.'],
      ['.','.','.','.','P'],
      ['.','.','.','.','.'],
      ['R','K','.','.','.'],
    ]

  state.board = whitewins

  it "it should take the king" do
    state.bestMove.to_s.should == "a1-a6"
  end

  it "scoreGen should calculate the correct score for white" do
    state.scoreGen(whitewins, 'W').should == 700
  end

  it "scoreGen should calculate the correct score for black" do
    state.scoreGen(whitewins, 'B').should == -700
  end

end
