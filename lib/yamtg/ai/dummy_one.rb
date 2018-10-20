require 'yamtg/ai/controller'

module YAMTG
    # Simple AI
    class AiDummyOne < AiController
        #
        # Main Phase
        #
        def on_first_main_phase
            play_some_land

            avail_mana = count_available_mana

            # play some creatures
            loop do
                # TODO: colors
                creature = @actor.find_card_in_hand { |card| card.type?(:Creature) && (card.cost.total <= avail_mana) }
                break unless creature

                acquire_mana creature.cost
                @actor.play_card creature
                avail_mana -= creature.cost.total
            end
        end
    end
end
