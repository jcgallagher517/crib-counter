require_relative "cribbage"

puts "Welcome to Cribbage Counter!"

puts "Enter your own cards as [value] [suit], separated by commas:"
input = gets.split(',')
          .map { |s| s.split(' ') }
          .map { |c| Cribbage::Card.new(c[0], c[1]) }
if input.length != 4
  STDERR.puts("Your hand should contain exactly four cards.")
  exit(1)
elsif input.uniq.length < 4
  STDERR.puts("Your hand should not contain duplicate cards.")
  exit(1)
end

puts "Now enter the cut card:"
cut = Cribbage::Card.new(*gets.split(' '))

def crib?
  puts "Is this the dealer's crib? (y/n):"
  case (input = gets)
  when /^y/i
    true
  when /^n/i
    false
  else
    puts "Please answer either yes or no!"
    crib?
  end
end
crib = crib?

hand = Cribbage::Hand.new(input, cut, crib)

hand.cards.each do |card|
  puts card
end
