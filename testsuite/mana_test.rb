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

require 'yamtg/mana'
require 'test/unit'

class TestMana < Test::Unit::TestCase
    include YAMTG

    def test_colors
        assert_equal( :white, 1.white.color )
        assert_equal( :white, (1.white + 8000.colorless).color )
        assert_equal( :colorless, Mana.new.color )
        assert_equal( :colorless, 8000.colorless.color )
    end

    def test_calculation
        assert_equal( 2, 2.black.total )
        assert_equal( 5, (2.black + 3.red).total )
        assert_equal( 1, (3.black - 2.colorless).total )
        assert_equal( 1, (3.black - 2.colorless).total )
        assert_equal( 0, (1.black - 1.black).total )
        assert_equal( 0, (1.black - 1.colorless).total )
        assert_equal( 1,           ((2.colorless + 1.red + 1.black) - 3.colorless).total )
        assert_equal( 3,           ((2.colorless + 1.red + 3.black) - 3.black).total )
        assert_equal( :red,        ((2.colorless + 1.red + 3.black) - 3.black).color )
        assert_equal( :multicolor, ((3.colorless + 1.red + 4.black) - 3.black).color )
        assert_raise( RuntimeError ) { 1.colorless - 1.black }
        assert_raise( RuntimeError ) { 1.red - 1.white }
    end

    def test_comparison
        assert( 1.black == 1.black )
        assert( 1.black < 2.black )
        assert( !(1.black < 1.black) )
        assert( !(1.black > 1.black) )
        assert(   1.colorless < 1.black )       # can't substract from colorless (TODO throw?)
        assert( !(1.colorless > 1.black) )
    end
end
