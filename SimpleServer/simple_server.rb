require "socket"


server = TCPServer.new(12345)
while (session = server.accept)
  session.puts "Hello there"
  session.close
end


