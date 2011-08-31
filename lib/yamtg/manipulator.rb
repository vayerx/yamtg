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
    # Proxy between game-side Player and Controller on remote-side (person or AI)
    class Manipulator
        attr_accessor :game, :player
        def initialize( game, player )
            @game = game
            @player = player
        end

        def draw_card( amount = 1 )
            @player.draw amount
        end

        def discard_card( index_or_range = 0 )
            @player.discard index_or_range
        end

        def play_card( card )
            # TODO triggers, actions, etc.

            if card.permanent?                  # TODO card-dependent logic!
                @player.battlefield << card
            else
                @player.graveyard << card
            end
        end
    end
end
