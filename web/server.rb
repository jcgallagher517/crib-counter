require 'webrick'
require 'erb'
require 'cgi'
require_relative '../lib/cribbage'

PORT = 3000

server = WEBrick::HTTPServer.new :Port => PORT, :DocumentRoot => "/"
trap "INT" do server.shutdown end

server.mount("/style.css", WEBrick::HTTPServlet::FileHandler, "./public/style.css")

# Input form
server.mount_proc "/" do |req, res|
  template = File.read(File.join(__dir__, "views", "form.html.erb"))
  res.content_type = "text/html"
  res.body = ERB.new(template).result(binding)
end

# Result of counting
server.mount_proc "/result" do |req, res|

  # collect inputed cards
  inp_cards = (1..4).map { |i| req.query["card#{i}"] || "" }
  inp_cut = req.query["cut"] || ""
  crib = req.query["crib"] == "on" ? true : false

  # process and count hand
  inp_cards.map! { |c| Cribbage::Card.new(c.split(' ')) }
  inp_cut = Cribbage::Card.new(inp_cut.split(' '))
  hand = Cribbage::Hand.new(inp_cards, inp_cut, crib)

  template = File.read(File.join(__dir__, "views", "result.html.erb"))
  res.content_type = "text/html"
  res.body = ERB.new(template).result(binding)

end

server.start
