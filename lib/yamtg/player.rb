#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2011, Vasiliy Yeremeyev <vayerx@gmail.com>,                   #
#    (C) 2007, Stefan Rusterholz (rubyoh).                                  #
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

require 'mana'

module YAMTG
    class Player
        attr_reader   :name
        attr_reader   :number
        attr_reader   :decksize
        attr_reader   :handsize
        attr_reader   :stack
        attr_reader   :hand
        attr_reader   :field
        attr_reader   :graveyard
        attr_accessor :pool
        attr_accessor :health

        def initialize(name, decksize, health=20)
            @name      = name.freeze
            @pool      = Mana.new
            @health    = life
            @decksize  = decksize
            @handsize  = 0
            @stack     = Stack.new
            @field     = Stack.new
            @graveyard = Stack.new
            @hand      = Stack.new
        end

        def cards_left?
            @decksize.zero? ? nil : @decksize
        end

        def dead?
            @health <= 0
        end
    end
end
