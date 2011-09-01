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

require 'yamtg/mana'
require 'yamtg/deck'
require 'yamtg/stack'

module YAMTG
    class Player
        attr_reader   :name
        attr_accessor :health
        attr_accessor :handsize
        attr_accessor :hand
        attr_accessor :battlefield
        attr_accessor :graveyard
        attr_accessor :mana

        def initialize( name, health = 20, handsize = 7 )
            @name       = name.freeze
            @health     = health
            @handsize   = handsize
            @hand       = []
            @battlefield= []
            @deck       = Deck.new
            @graveyard  = Stack.new
            @mana       = Mana.new
        end

        def deck( *var )
            return @deck if var.empty?
            raise ArgumentError, "Invalid args amount #{var.size}" if var.first.is_a? Deck and var.size != 1
            @deck = var.first.is_a?( Deck ) ? var.first : Deck.new( var.first )
            @deck.each {|v| v.owner = self }
        end

        def cards_left?
            not @deck.empty?
        end

        def dead?
            @health <= 0
        end

        def draw( amount = 1 )
            @hand.concat @deck.draw( amount )
        end

        def discard( index_or_range = 0 )
            discarded = @hand.slice! index_or_range
            @graveyard.concat discarded
            discarded
        end

        def add_mana( mana )
            @mana += mana
        end
    end
end
