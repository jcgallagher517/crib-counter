require 'webrick'
require 'erb'
require 'cgi'
require_relative '../lib/cribbage'

PORT = 3000

server = WEBrick::HTTPServer.new :Port => PORT, :DocumentRoot => "/"
trap "INT" do server.shutdown end

server.mount("/style.css", WEBrick::HTTPServlet::FileHandler, "./public/style.css")

# input form
server.mount_proc "/" do |req, res|
  template = File.read(File.join(__dir__, "views", "form.html.erb"))
  res.content_type = "text/html"
  res.body = ERB.new(template).result(binding)
end

# results display page
server.mount_proc "/result" do |req, res|

  # collect inputed cards
  inp_cards = (1..4).map { |i| req.query["card#{i}"] || "" }
  inp_cut = req.query["cut"] || ""
  crib = req.query["crib"] == "on" ? true : false

  # create hand
  inp_cards.map! { |c| Cribbage::Card.new(*c.split(' ')[0..1]) }
  inp_cut = Cribbage::Card.new(*inp_cut.split(' ')[0..1])
  hand = Cribbage::Hand.new(inp_cards, inp_cut, crib)
  result = hand.count

  template = File.read(File.join(__dir__, "views", "result.html.erb"))
  res.content_type = "text/html"
  res.body = ERB.new(template).result(binding)

end

server.start
