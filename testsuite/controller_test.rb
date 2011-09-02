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

require 'yamtg/sets/alpha'
require 'yamtg/controller'
require 'yamtg/game'
require 'test/unit'
require 'pp'

class TestController < Test::Unit::TestCase
    include YAMTG

    def setup
        @game = Game.new
        @player1 = Player.new 'Player1'
        @game.add_player @player1, Controller.new
    end

    def test_untapping
        @player1.deck('Mountain' => 20)
        @game.start_game

        assert(@player1.battlefield.empty?)
        @player1.battlefield << get_card('Dwarven Soldier').tap
        assert(@player1.battlefield.first.tapped?)

        @game.next_round
        assert(!@player1.battlefield.first.tapped?)
    end
end
