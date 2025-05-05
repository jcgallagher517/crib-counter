module Cribbage

    Suits = ["Clubs", "Diamonds", "Hearts", "Spades"]
    Values = ["Ace"] + (2..10).map(&:to_s) + ["Jack", "Queen", "King"]

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
      if cards.length != 4
        raise ArgumentError, "Your hand should contain four cards."
      elsif cards.uniq.length < 4 || cards.include?(cut)
        raise ArgumentError, "All cards in your hand should be distinct."
      end
    end

    def crib?
      return @crib
    end


    # private

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



    def runs
      # for runs, face-cards are sequential
      vals = Values.zip(1..13).to_h
      card_vals = (@values.map { |v| vals[v] } + vals[cut.value]).sort


    end



    def pairs

    end


    def fifteens
      # face-cards count as ten for fifteen counting
      vals = Values.zip((1..10).to_a + [10]*3).to_h
      card_vals = @values.map { |v| vals[v] } + vals[cut.value]
      

    end
    


  end


end
