module Cribbage

    Suits = ["Clubs", "Diamonds", "Hearts", "Spades"]
    Values = ["Ace"] + (2..10).to_a.map(&:to_s) + ["Jack", "Queen", "King"]

  class Card

    attr_reader :value, :suit

    def initialize(value, suit)

      if (match = Values.select { |s| s.match?(/^#{Regexp.escape(value)}/i) })
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

    attr_reader :cards, :cut

    def initialize(cards, cut, crib = false)
      @cards = cards
      @cut = cut
      @crib = crib
      @suits = cards.map { |card| card.suit }
      @values = cards.map { |card| card.value }
      if cards.uniq.length != 4 || cards.include?(cut)
        raise ArgumentError, "All cards in hand should be distinct!"
      end
    end

    def crib?
      return @crib
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
