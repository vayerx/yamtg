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

require 'yamtg/set'
require 'enumerator'    # ruby 1.8

module YAMTG
    class Deck < Array
        def initialize( cards = [], autoload = :load )
            case cards
            when Hash
                cards.each { |card, amount| fill( card, length, amount ) }
            when Array
                cards.flatten.each_slice( 2 ) { |v| fill( v.first, length, v.last ) if v.size == 2 }
            else
                raise ArgumentError, "Deck: can't handle #{cards.class}"
            end

            load if autoload == :load
        end

        def load
            map! { |card| get_card card if card.is_a? String }
        end

        def draw( amount = 1 )
            raise RuntimeError, "Not enough cards in deck" if size < amount
            shift amount
        end
    end
end
