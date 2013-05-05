require 'net/telnet.rb'

class Client

  $move = nil

  def initialize
    @server = Net::Telnet::new(
      "Host" => "imcs.svcs.cs.pdx.edu",
      "Port" => "3589",
      "Timeout" => 20,
      "Prompt" => //)
  end

  def register
    write("register chesire wonderland")
  end

  def login
    write("me chesire wonderland")
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

  def offerGame(color="W", time=600, op_time=600)
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
      $move = move.match(/[a-f]\d-[a-f]/)
      return false
    else
      throw "Error: First move cannot be decided, color is #{color}"
    end
  end

  def waitForMove()
    move = match(/.*/)
    $move = move.match(/[a-f]\d-[a-f]/).to_s
  end

  def move(movestring)
    $move = write(movestring)
    puts "Other players move is #{$move}"
  end

  def getOpponentMove
    puts "Opponent move was #{$move}"
    return $move
  end

  def write(command)
    @server.cmd(command) { |c| print c }
  end

  def match(regex)
    @server.waitfor(regex)
  end

  def disconnect
    @server.close
  end

end
