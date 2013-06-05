
require File.expand_path('../../lib/state.rb', __FILE__)


describe State, "#gameOver?" do

  state = State.new

  whitewins = [
      ['.','q','b','n','r'],
      ['p','p','p','p','p'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['P','P','P','P','P'],
      ['R','N','B','Q','K'],
    ]
  blackwins= [
      ['k','q','b','n','r'],
      ['p','p','p','p','p'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['P','P','P','P','P'],
      ['R','N','B','Q','.'],
    ]
   draw = [
      ['k','.','.','.','.'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['.','.','.','.','K'],
    ]

  it "the game should end if the white king is gone" do
    state.gameOver?(whitewins).should == true
  end

  it "the game should end if the black king is gone" do
    state.gameOver?(blackwins).should == true
  end

  it "the game should end there has been MAXTURNS" do
    state.gameOver?(draw, 81).should == true
  end

end
