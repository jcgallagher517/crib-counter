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

  # create hand
  inp_cards.map! { |c| Cribbage::Card.new(*c.split(' ')[0..1]) }
  inp_cut = Cribbage::Card.new(*inp_cut.split(' ')[0..1])
  hand = Cribbage::Hand.new(inp_cards, inp_cut, crib)

  result = hand.count

  # probably delete the rest of this stuff using new count method

  # define results
  res_suits = hand.count_suits
  res_jack = hand.right_jack
  res_pairs = hand.pairs
  res_fifteens = hand.fifteens
  res_runs = hand.runs

  # add up all points
  res_total = res_suits ? res_suits : 0
  res_total += res_jack ? 1 : 0
  res_total += res_pairs ? 2*res_pairs.length : 0
  res_total += res_fifteens ? 2*res_fifteens.length : 0
  res_total += res_runs ? res_runs.map(&:length).sum : 0

  template = File.read(File.join(__dir__, "views", "result.html.erb"))
  res.content_type = "text/html"
  res.body = ERB.new(template).result(binding)

end

server.start
