require File.expand_path('../../lib/square.rb', __FILE__)


describe Square, "(1,1)" do

  square = Square.new(1,1)

  it "x returns 1" do
    square.x.should == 1
  end

  it "y returns 1" do
    square.y.should == 1
  end

end
