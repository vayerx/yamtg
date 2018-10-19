#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2011, Vasiliy Yeremeyev <vayerx@gmail.com>                    #
#                                                                           #
#    This program is free software; you can redistribute it and/or modify   #
#    it under the terms of the GNU General Public License as published by   #
#    the Free Software Foundation; either version 2 of the License, or      #
#    (at your option) any later version.                                    #
#                                                                           #
#    This program is distributed in the hope that it will be useful,        #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of         #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the           #
#    GNU General Public License for more details.                           #
#                                                                           #
#    You should have received a copy of the GNU General Public License      #
#    along with this program. If not, see <http://www.gnu.org/licenses/>    #
#    or write to the Free Software Foundation, Inc.,                        #
#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.              #
#############################################################################

require 'yamtg/controller'

module YAMTG
    class AiController < Controller
        def play_some_land
            land = @actor.find_card_in_hand { |card| card.type? :Land }
            @actor.play_card land if land
        end

        # get amount of available mana on the battlefield
        def count_available_mana
            avail_mana = battlefield(:self).count do |card, _|
                # TODO: tap for multiple mana
                !card.tapped? && card.has?(:tap_for_mana)
            end

            mana.total + avail_mana
        end

        def aquire_mana(cost)
            # TODO: support mana colors
            # TODO: aquire optimal amount of mana
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
