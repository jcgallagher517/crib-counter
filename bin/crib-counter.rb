#!/usr/bin/env ruby

require_relative "../lib/cribbage"

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
if input.include?(cut)
  STDERR.puts("Cut card should not be a duplicate.")
  exit(1)
end

def is_crib?
  puts "Is this the dealer's crib? (y/n):"
  case (input = gets)
  when /y/i
    true
  when /n/i
    false
  else
    puts "Please answer either yes or no! (y/n)"
    is_crib?
  end
end
crib = is_crib?

hand = Cribbage::Hand.new(input, cut, crib)
result = hand.count

# display hand
puts "\nYour hand contains the following cards:"
puts Cribbage.card_array_to_s(hand.cards)
puts "The #{hand.cut} was cut."
if hand.crib?
  puts "And it's the dealer's crib."
end

if result[:pairs] != 0
  puts "\nYou have the following pairs:"
  hand.pairs.each do |pair|
    puts Cribbage.card_array_to_s(pair)
  end
  puts "+#{result[:pairs]} points!"
end

if result[:fifteens] != 0
  puts "\nYou have the following fifteens:"
  hand.fifteens.each do |fifteen|
    puts Cribbage.card_array_to_s(fifteen)
  end
  puts "+#{result[:fifteens]} points!"
end

if result[:runs] != 0
  puts "\nYou have the following runs:"
  hand.runs.each do |run|
    puts Cribbage.card_array_to_s(run)
  end
  puts "+#{result[:runs]} points!"
end

if result[:suits] != 0
  puts "\nYour cards are all of the same suit."
  puts "+#{result[:suits]} points!"
end

if result[:jack] != 0
  puts "\nYour #{hand.right_jack} is the right jack."
  puts "+1 point!"
end

if (points = result.values.sum) != 0
  puts "\nYour hand is worth #{points} points!"
else
  puts "\nYour hand is worth 19 points! Sorry!"
end
