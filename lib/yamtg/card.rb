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

require 'yamtg/mana'

module YAMTG
    class Card
        class << self
            def inherited( subclass )
                subclass.init
            end

            def init
                class_variable_set :@@cost          , Mana.new
                class_variable_set :@@types         , []
                class_variable_set :@@colors        , []
                class_variable_set :@@name          , ""
                class_variable_set :@@description   , ""
                class_variable_set :@@legend        , ""
            end

            attr_accessor :params

            def param( name )
                define_method( name ) { |*args|
                    return params[name] if args.empty?
                    params[name] = args.first
                }
            end

            def cost( *mana )
                class_variable_set :@@cost, mana.inject( Mana.new ) { |a, b| a + b }
            end

            def name( val )     class_variable_set( :@@name, val );    end
            def type( *val )    class_variable_set( :@@types, val );   end
            def legend( val )   class_variable_set( :@@legend, val );  end

            def ability( *val )
                # TODO
            end
            def event( *val )
                # TODO
            end

            def flying
                # TODO
            end
            def first_strike
                # TODO
            end

            def description( val )
                class_variable_set :@@description, val
            end
        end

        attr_reader :name           # Name of this card
        attr_reader :cost           # Mana this card costs to play
        attr_reader :description    # Description of abilities of this card
        attr_reader :legend         # An entertaining string with a piece of story for the player
        # attr_reader :tokens         # How many of any token is on this card
        # attr_reader :zone           # :library, :hand, :field, :graveyard, :out_of_game, :transit_<from>_<to>

        attr_accessor   :power, :toughness

        attr_reader     :owner

        def initialize( *params )
            puts "CARD::CARD(#{self}/#{self.class}) in=#{instance_variables}  cl=#{self.class.class_variables}"
            # @name        = self.class.class_variables[ :@@name ]
            @cost        = @@cost
            @colors      = @@colors || ( @cost.infer_color if @cost )
            @types       = @@types
            @description = @@description
            @legend      = @@legend

            @tapped       = false
            # @zone         = nil
            @attachements = []    # cards (enchantments, equipments) attached to this card
            # @tokens       = Hash.new(0)
        end

        def class?(klass)
            @class == klass
        end

        def type?(type)
            @types.include?(type)
        end

        def color?(color)
            @colors.include?(color)
        end

        def tapped?
            @tapped
        end

        def attach(card)
            @attachements << card
        end

        def detach(card)
            @attachements.delete(card)
        end
    end

    class Source < Card
    end
end
