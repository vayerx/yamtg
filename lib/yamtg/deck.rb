require 'yamtg/set'

module YAMTG
    class Deck < Array
        def initialize(cards = [], autoload = :load)
            case cards
            when Hash
                cards.each { |card, amount| fill(card, length, amount) }
            when Array
                cards.flatten.each_slice(2) { |v| fill(v.first, length, v.last) if v.size == 2 }
            else
                raise ArgumentError, "Deck: can't handle #{cards.class}"
            end

            load if autoload == :load
        end

        def load
            map! { |card| get_card card if card.is_a? String }
        end

        def draw(amount = 1)
            raise 'Not enough cards in deck' if size < amount

            shift amount
        end
    end
end
