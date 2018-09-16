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

require 'yamtg/sets/sets'
require 'test/unit'
require 'pp'

unless defined? KeyError # ruby 1.8
    class KeyError < StandardError
    end
end

class TestCore < Test::Unit::TestCase
    include YAMTG

    def new_card( name, klass = Card )
        card = get_card name
        assert( card && card.is_a?(klass) )
        assert_equal( name, card.name )
        card
    end

    def test_invalid
        alpha = card_set 'Alpha'
        assert_raise( KeyError ) {
            begin
                alpha.card( 'invalid-CARD-name' )
            rescue IndexError       # ruby 1.8
                raise KeyError
            end
        }
    end

    def test_autofetcher
        assert_nothing_raised do
            YAMTG::get_card 'Cloud Phantom'
            YAMTG::get_card 'Cloud Phantom', 'Alpha'
        end
        assert_raise( KeyError ) {
            begin
                YAMTG::get_card 'Cloud Phantom', 'invalid-SET-name'
            rescue IndexError       # ruby 1.8
                raise KeyError
            end
        }
    end

    def test_Phantom
        card = new_card 'Cloud Phantom', Creature
        assert_equal( :Illusion, card.type )
        assert( card.type? :Illusion )
        assert( !card.type?( :NotIllusion ) )
        assert( card.permanent? )
        assert_equal( :black, card.color )
        assert_equal( 3, card.cost.total )
        assert_equal( 3, card.power )
        assert_equal( 5, card.toughness )
    end

    # independent attributes (compared with Cloud Phantom)
    def test_Zephyr
        card = new_card 'Zephyr of the sky', Creature
        assert_equal( :Bird, card.type )
        assert_equal( :blue, card.color )
        assert_equal( 3, card.cost.total )
        assert_equal( 3, card.power )
        assert_equal( 1, card.toughness )
        assert( card.can_attack? )
        assert( card.has? :vigilance )
        assert( !card.has?( :first_strike ) )
    end

    source 'Duress' do
        cost        1.black
        description 'Target oppenent reveals his or her hand...'
    end

    # Source
    def test_Duress
        card = new_card 'Duress', Source
        assert( !card.permanent? )
        assert_equal( :black, card.color )
        assert_equal( 1, card.cost.total )
    end

    # only instance variables should be modified on card manipulation
    def test_modification
        card1 = new_card 'Zephyr of the sky'
        assert_equal( 3, card1.power )
        card1.power = 1
        assert_equal( 1, card1.power )

        card2 = new_card 'Zephyr of the sky'
        assert_equal( 3, card2.power )
    end

    # "dynamic" attributes
    def test_Stonewall
        card = new_card 'Stonewall', Defender
        assert( !card.can_attack? )
        assert_equal( 0, card.power )       # initial power (isn't defined in spec)
        assert_equal( 0, card.anger )       # initial anger (card-specific)
        card.anger = 1
        assert_equal( 3, card.power )       # modified power
    end
end
