module Cribbage

    Suits = ["Clubs", "Diamonds", "Hearts", "Spades"]
    Values = ["Ace"] + (2..10).map(&:to_s) + ["Jack", "Queen", "King"]

  class Card

    include Comparable 
    attr_reader :value, :suit

    def initialize(value, suit)

      if value.to_i == 1
        @value = Values.first
      elsif (match = Values.select { |s| s.match?(/^#{Regexp.escape(value)}/i) })
        @value = match.first
      else
        raise ArgumentError, "Invalid card value given"
      end

      if (match = Suits.select { |s| s.match?(/^#{Regexp.escape(suit)}/i) })
        @suit = match.first
      else
        raise ArgumentError, "Ivalid card suit given"
      end

    end


    def inspect
      "Card(value='#{value}', suit='#{suit}')"
    end

    def to_s
      "#{value} of #{suit}"
    end


    def ==(other)
      other.is_a?(Card) && value == other.value && suit == other.suit
    end

    def eql?(other)
      self == other
    end

    def hash
      [value, suit].hash
    end

    def <=>(other)
      vals = Values.zip(1..13).to_h
      vals[value] <=> vals[other.value]
    end
    
  end



  class Hand

    attr_reader :cards, :cut

    def initialize(cards, cut, crib = false)
      @cards = cards
      @cut = cut
      @crib = crib
      @suits = cards.map { |card| card.suit }
      @values = cards.map { |card| card.value }
      if cards.length != 4
        raise ArgumentError, "Your hand should contain four cards."
      elsif cards.uniq.length < 4 || cards.include?(cut)
        raise ArgumentError, "All cards in your hand should be distinct."
      end
    end

    def crib?
      return @crib
    end

    def count_suits
      u_suits = @suits.uniq
      if !@crib && u_suits.length == 1
        return u_suits.first == cut.suit ? 5 : 4
      elsif @crib && u_suits.length == 1 && u_suits.first == cut.suit
        return 5
      end
    end

    def right_jack
      jack = cards.select { |c| c.value == "Jack" && c.suit == cut.suit }
      return jack ? jack.first : nil
    end

    def pairs
      (cards + [cut]).combination(2).select { |p| p[0].value == p[1].value }
    end

    def fifteens
      # face-cards count as ten for fifteen counting
      vals = Values.zip((1..10).to_a + [10]*3).to_h
      combos = (2..5).flat_map { |n| (cards + [cut]).combination(n).to_a }
      combos.select { |c| c.map { |card| vals[card.value] }.sum == 15 }
    end


    # minor bug in this code, run more tests, it doesn't work all the time
    def runs
      # for runs, face-cards are sequential
      vals = Values.zip(1..13).to_h
      5.downto(3) do |n|
        combos = (cards + [cut]).combination(n).to_a
        combos.select! { |c| c.map { |card| vals[card.value] }
                           .sort
                           .each_cons(2)
                           .all? { |a, b| b - a == 1 } }
        if !combos.empty?
          return combos.map(&:sort)
        end
      end
      return nil
    end





  end

end
