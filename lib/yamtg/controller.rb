module YAMTG
    # Remote-side player operating via Manipulator
    class Controller
        attr_accessor :actor    # Manipulator

        def initialize(actor = nil)
            @actor = actor
        end

        #
        # Beginning Phase: untap, upkeep, and draw
        #
        def on_untap_step
            battlefield(:self).each { |card, _| card.untap if card.tapped? }
        end

        def on_upkeep_step
        end

        def on_draw_step
            @actor.draw_card
        end

        #
        # First Main Phase
        #
        def on_first_main_phase
        end

        #
        # Combat Phase
        #
        def on_beginning_of_combat_step
        end

        def on_declare_attackers_step
        end

        def on_declare_blockers_step
        end

        def on_combat_damage_step
        end

        def on_end_of_combat_step
        end

        #
        # Second Main Phase
        #
        def on_second_main_phase
        end

        #
        # Ending Phase
        #
        def on_end_step
        end

        # Choose cards to discard to graveyard
        def on_discard_cards(amount)
            0...amount
        end

        # Choose cards to exile
        def on_exile_cards(amount)
            0...amount
        end

    protected   # shortcuts
        def max_hand_size
            @actor.max_hand_size
        end

        def battlefield(name = :all, &block)
            if block_given?
                @actor.battlefield(name, &block)
            else
                @actor.to_enum(:battlefield, name)
            end
        end

        def mana
            @actor.mana
        end
    end
end
