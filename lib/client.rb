require 'net/telnet.rb'
require 'debugger'

class Client

  def initialize
    @move = 'UNSET'
    @server = Net::Telnet::new(
      "Host" => "imcs.svcs.cs.pdx.edu",
      "Port" => "3589",
      "Timeout" => 12000,
      "Prompt" => //)
  end

  def register
    write("register chesire wonderland")
  end

  def login
    write("me cheshire wonderland")
    match(/201 hello chesire\n/)
  end

  def listGames
    list = write("list")
    match(/211 .*/)
  end

  def help
    list = write("help")
    match(/210 .*/)
  end

  def offerGame(color="W", time='5:00', op_time='5:00')
    write("offer #{color} #{time} #{op_time}")
    match(/103 \d+ game waiting for offer acceptance\n/)
    output = match(/10\d (W|B) \d+:\d+ \d+:\d+ game starts\n/)
    return firstMove?(output.match(/W|B/).to_s)
  end

  def acceptGame(id)
    write("accept #{id}")
    output = match(/10\d (W|B) \d+:\d+ \d+:\d+ game starts\n/)
    return firstMove?(output.match(/W|B/).to_s)
  end

  def firstMove?(color)
    if color == 'W'
      return true
    elsif color == 'B'
      move = match(/.*/)
      @move = move.match(/[a-f]\d-[a-f]/)
      return false
    else
      throw "Error: First move cannot be decided, color is #{color}"
    end
  end

  def waitForMove()
    move = match(/.*[a-f]\d-[a-f]\d.*/)
    @move = move.match(/[a-f]\d-[a-f]\d/).to_s
  end

  def move(movestring)
    if not movestring.nil?
      @move = write(movestring.to_s)
    else
      throw "Error: nil movestring"
    end
  end

  def getOpponentMove
    return @move
  end

  def write(command)
    @server.cmd(command) { |c| print c }
  end

  def match(regex)
    @server.waitfor(regex)
  end

  def exit
    @server.close
  end

end
