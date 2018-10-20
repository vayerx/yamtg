module YAMTG
    # Proxy between game-side Player and Controller on remote-side (person or AI)
    class Manipulator
        attr_accessor :game, :player
        def initialize(game, player)
            raise ArgumentError unless player.is_a? Player

            @game = game
            @player = player
        end

        def draw_card(amount = 1)
            @player.draw amount
        end

        def discard_card(index_or_range = 0)
            @player.discard index_or_range
        end

        def play_card(card)
            # TODO: triggers, actions, etc.
            raise IndexError, "No such card in hand: #{card}" unless @player.hand.index card

            # TODO: card-specific costs
            raise "Not enough mana to play #{card.inspect}: #{@player.mana} < #{card.cost}" if @player.mana < card.cost

            @player.mana -= card.cost

            # TODO: card-dependent logic!
            (card.permanent? ? @player.battlefield : @player.graveyard) << card

            card.controller = @player

            # pp @player
        end

        def play_card_ability(card, ability)
            raise "Card has no ability #{ability}" unless card.has? ability

            # TODO: legality checks

            handler = card.abilities[ability]
            action = handler[:action]
            action.call(nil, card) # TODO: arena?
        end

        def find_card_in_hand(&block)
            index = @player.hand.index(&block)
            index ? @player.hand[index] : nil
        end

        def player_name
            @player.name
        end

        def max_hand_size
            @player.max_hand_size
        end

        def battlefield(name = :all)
            name = player_name if name == :self
            @game.players.each do |player|
                player.battlefield.each { |card| yield card, player.name } if (name == :all) || (player.name == name)
            end
        end

        def mana
            @player.mana
        end
    end
end
