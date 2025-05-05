module Cribbage

    Suits = ["Clubs", "Diamonds", "Hearts", "Spades"]
    Values = ["Ace"] + (2..10).to_a + ["Jack", "Queen", "King"]

  class Card

    attr_reader :value, :suit

    def initialize(value, suit)

      if (2..10).to_a.include?(value.to_i)
        @value = value.strip
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
    
  end



  class Hand

    attr_reader :cards

    def initialize(cards, cut, crib = false)
      @cards = cards
      @suits = cards.map { |card| card.suit }
      @values = cards.map { |card| card.value }
      @cut = cut
      @crib = crib
    end


    private

    def count_suits

      
    end


    def count_jack

      jacks = Suits.map { |suit| Card.new("Jack", suit) }

    end



    def count_runs

    end

    def count_pairs

    end


    def count_fifteens

    end
    


  end


end
