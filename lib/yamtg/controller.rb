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

module YAMTG
    class Controller
        attr_accessor :actor    # Manipulator

        def initialize
            @actor = nil
        end

    protected
        def hand
            @actor.player.hand      # I wish I could return constant reference
        end

        def handsize
            @actor.player.handsize
        end

    public
        #
        # Beginning Phase: untap, upkeep, and draw
        #
        def on_untap_step
        end
        def on_upkeep_step
        end
        def on_draw_step
            @actor.draw_card
        end

        #
        # Main Phase
        #
        def on_main_phase
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
        # Ending Phase
        #
        def on_end_step
        end
        def on_cleanup_step
            @actor.discard_card(0...(@hand.size - @handsize)) if hand.size > handsize
        end
    end
end
