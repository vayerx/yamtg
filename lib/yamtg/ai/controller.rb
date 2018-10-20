require 'yamtg/controller'

module YAMTG
    # AI helper
    class AiController < Controller
        def play_some_land
            land = @actor.find_card_in_hand { |card| card.type? :Land }
            @actor.play_card land if land
        end

        # get amount of available mana on the battlefield
        def count_available_mana
            avail_mana = battlefield(:self).count do |card, _|
                # TODO: tap for multiple mana
                # TODO: support other mana sources
                !card.tapped? && card.has?(:tap_for_mana)
            end

            mana.total + avail_mana
        end

        def acquire_mana(cost)
            # TODO: support mana colors
            # TODO: acquire optimal amount of mana
            # TODO: atomicity -- don't play cards abilities if there is not enough mana
            found = 0
            battlefield(:self).each do |card|
                next if card.tapped? || !card.has?(:tap_for_mana)

                @actor.play_card_ability card, :tap_for_mana
                # TODO: add :tap_for_mana "value"
                if (found += 1) > cost.total
                    break
                end
            end
        end
    end
end
