require 'net/telnet.rb'

class Client

  def initialize
    @server = Net::Telnet::new(
      "Host" => "imcs.svcs.cs.pdx.edu",
      "Port" => "3589",
      "Timeout" => 10,
      "Prompt" => /[$%#>] \z/)
  end

  def register
    write("register chesire wonderland")
  end

  def login
    write("me chesire wonderland")
    match("202\s.*")
  end

  def listGames
    write("list")
  end

  def offerGame(color="W", time=600, op_time=600)
    write("offer #{color} #{time} #{op_time}")
  end

  def acceptGame(id)
    write("accept #{id}")
  end

  def move(movestring)
    write(movestring)
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
