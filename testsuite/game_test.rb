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

class TestGame < Test::Unit::TestCase
    include YAMTG

    creature 'Ezuri\'s Archers' do
        cost        1.green
        power       1
        toughness   2
        reach
    end

    def setup
        @game = Game.new

        @gargoyle = get_card 'Gargoyle'         # 2/2, flying
        @pegasus  = get_card 'Pegasus'          # 2/2, flying, first strike
        @archers  = get_card 'Ezuri\'s Archers' # 1/2, reach
        @phantom  = get_card 'Cloud Phantom'    # 3/5
    end

    def test_Discard_excessive_cards
        player = Player.new 'Player'
        player.deck( [ 'Dwarven Soldier', 1, 'Cave Troll', 4, 'Mountain Ogre', 4 ] )
        @game.add_player player, Controller.new

        @game.start_game
        assert( player.graveyard.empty? )
        @game.next_round     # 7 cards
        assert( player.graveyard.empty? )
        @game.next_round     # 8 cards - 1 card should be discarded
        assert( !player.graveyard.empty? )
        assert_equal( 'Dwarven Soldier', player.graveyard.first.name )
    end

    def test_Basic_blocking_abilities
        assert( @gargoyle.can_attack? && @pegasus.can_attack? && @phantom.can_attack? && @archers.can_attack? )
        assert( @gargoyle.can_block? && @pegasus.can_block? && @phantom.can_block? && @archers.can_block? )
        assert( @gargoyle.can_block? @pegasus )     # flying - flying
        assert( @gargoyle.can_block? @phantom )     # flying - basic
        assert( !@phantom.can_block?(@gargoyle) )   # basic - flying
        assert( @phantom.can_block? @archers )      # basic - basic

        @phantom.tap
        assert( !@phantom.can_block?(@archers) )    # basic tapped - basic
        assert( !@phantom.can_attack? && !@phantom.can_block? )
    end

    def test_Basic_damage_abilities
        # TODO
    end
end
