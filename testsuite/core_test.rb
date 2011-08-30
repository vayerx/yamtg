#!/usr/bin/env ruby
#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2011, Vasiliy Yeremeyev <vayerx@gmail.com>.                   #
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

require "yamtg/sets/alpha.rb"
require "test/unit"

class TestCore < Test::Unit::TestCase
    include YAMTG
    def setup
        @AlphaSet = card_set 'Alpha'
    end

    def test_Phantom
        card_class = @AlphaSet.card( 'Cloud Phantom' )
        assert( card_class )
        card = card_class.new
        assert( card )
        assert( card.kind_of? Creature )
        assert_equal( 'Cloud Phantom', card.name )
        assert_equal( 3, card.power )
        assert_equal( 5, card.toughness )
        puts card.cost.inspect
        assert_equal( "Illusion", card.type )
        assert_equal( "black", card.color )
    end

    def test_Zephyr
        card = @AlphaSet.card( 'Zephyr of the sky' ).new
        assert_equal( 'Zephyr of the sky', card.name )
        assert_equal( 3, card.power )
        assert_equal( 1, card.toughness )
        puts card.cost.inspect
        assert_equal( "Bird", card.type )
        assert_equal( "blue", card.color )
    end

end
