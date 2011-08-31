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

require 'yamtg/manipulator'
require 'yamtg/player'
require 'enumerator'

module YAMTG
    class Game
        attr_reader :players

        def initialize
            @players = []
            @controllers = []
            @active_index = nil
        end

        def add_player( player, controller )
            @players << player
            controller.actor = Manipulator.new self, player
            @controllers << controller
        end

        def start_game( shuffle_cards = :shuffle )
            raise RuntimeError, "Can't start game -- no players" if @players.empty?
            @active_index = 0
            @players.each { |player| player.draw 6 }
            @players.each { |player| player.deck.shuffle! } if shuffle_cards == :shuffle
        end

        def next_round
            raise RuntimeError, "Game over" if game_over?
            do_player_step active_player
            next_player
        end

        def game_over?
            raise RuntimeError, "No players" if @players.empty?
            @players.all? { |player| player.dead? }
        end

    private
        def active_player       # TODO rename/split - return controller
            raise RuntimeError, "No active player -- game hasn't started" if @active_index == nil
            @controllers.fetch @active_index
        end

        def next_player
            return @active_index = nil if game_over?
            while @players[@active_index].dead? do
                @active_index = (@active_index + 1) % @players.size
            end
            true
        end

        def do_player_step( player )
            player.on_untap_step
            player.on_upkeep_step
            player.on_draw_step
            player.on_main_phase
            player.on_beginning_of_combat_step
            player.on_declare_attackers_step
            player.on_declare_blockers_step
            player.on_combat_damage_step
            player.on_end_of_combat_step
            player.on_end_step
            player.on_cleanup_step
        end
    end
end
