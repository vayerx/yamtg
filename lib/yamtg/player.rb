require 'yamtg/mana'
require 'yamtg/deck'

module YAMTG
    class Player
        attr_reader   :name
        attr_accessor :health
        attr_accessor :max_hand_size
        attr_accessor :hand
        attr_accessor :battlefield
        attr_accessor :graveyard
        attr_accessor :mana

        def initialize(name, health = 20, hand_size = 7)
            @name          = name.freeze
            @health        = health
            @max_hand_size = hand_size
            @hand          = []
            @battlefield   = []
            @deck          = Deck.new
            @graveyard     = []
            @mana          = Mana.new
        end

        def deck(*var)
            return @deck if var.empty?
            raise ArgumentError, "Invalid args amount #{var.size}" if var.first.is_a?(Deck) && (var.size != 1)

            @deck = var.first.is_a?(Deck) ? var.first : Deck.new(var.first)
            @deck.each { |v| v.owner = self }
        end

        def cards_left?
            !@deck.empty?
        end

        def dead?
            @health <= 0
        end

        def draw(amount = 1)
            @hand.concat @deck.draw(amount)
        end

        def discard(index_or_range = 0)
            discarded = @hand.slice! index_or_range
            @graveyard.concat discarded
            discarded
        end

        def add_mana(mana)
            @mana += mana
        end
    end
end
