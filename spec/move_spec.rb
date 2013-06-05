require File.expand_path('../../lib/move.rb', __FILE__)
require File.expand_path('../../lib/square.rb', __FILE__)


describe Move, "0,0 to 0,1" do

  fs = Square.new(0,0)
  ts = Square.new(0,1)
  move = Move.new(fs,ts)

  it "the chess square should convert to a6-a5" do
    move.to_s.should == "a6-a5"
  end

end

describe Move, "0,5 to 0,4" do

  fs = Square.new(0,5)
  ts = Square.new(0,4)
  move = Move.new(fs,ts)

  it "the chess square should convert to a1-a2" do
    move.to_s.should == "a1-a2"
  end

end
