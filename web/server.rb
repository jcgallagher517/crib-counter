
require 'webrick'
require 'erb'

PORT = 3000
ROOT = 'web/public'

server = WEBrick::HTTPServer.new :Port => PORT, :DocumentRoot => ROOT

trap 'INT' do server.shutdown end

server.mount_proc '/' do |req, res|
  res.body = 'Hello, World!'
end

server.start
