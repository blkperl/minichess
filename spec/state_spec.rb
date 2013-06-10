
require File.expand_path('../../lib/state.rb', __FILE__)


describe State, "#gameOver?" do

  state = State.new

  normal = [
      ['k','q','b','n','r'],
      ['p','p','p','p','p'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['P','P','P','P','P'],
      ['R','N','B','Q','K'],
    ]
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

  it "should return false if under maxturns and kings are alive" do
    state.gameOver?(normal).should == false
  end

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


describe State, "#scoreGen" do

  state = State.new

  missingPawns = [
      ['k','q','b','n','r'],
      ['p','p','p','p','p'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['.','.','.','.','.'],
      ['R','N','B','Q','K'],
    ]

  it "scoreGen should calculate the correct score for black" do
    state.scoreGen(missingPawns, 'B').should == 421
  end

  it "scoreGen should calculate the correct score for white" do
    state.scoreGen(missingPawns, 'W').should == -500
  end

end
