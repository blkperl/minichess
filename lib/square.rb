class Square
  attr_reader :x, :y

  def initialize(x,y)
    isNil?(x, y)
    @x = x
    @y = y
  end

  def isNil?(x, y)
    if x.nil? or y.nil?
      raise InvalidSquare, "Invalid chess square x: #{x} y: #{y}"
    end
  end

end
