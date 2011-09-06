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
            %w[name types colors description legend abilities].each { |name|
                define_method( name ) { |*val|
                    return class_variable_get( '@@' + name ) if val.empty?
                    class_variable_set( '@@' + name, val.first )
                }
            }

            def init
                class_variable_set :@@name, ""
                class_variable_set :@@cost, Mana.new
                class_variable_set :@@types, []
                class_variable_set :@@colors, []
                class_variable_set :@@description, ""
                class_variable_set :@@legend, ""
                class_variable_set :@@abilities, {}
            end

            def artifact
                types :artifact
            end

            def cost( *mana )
                return class_variable_get( :@@cost ) if mana.empty?
                class_variable_set( :@@cost, mana.inject( Mana.new ) { |a, b| a + b } )
            end

            def type( *name )
                types( name )
            end

            def ability( name, *val )
                abilities[name] = val       # TODO custom abilities (name, *cost, &action)
            end
            def tap( *val, &descr )
                # TODO
            end
            def event( *val )
                # TODO
            end
        end

    protected   # card owner should be read only by Cards (Controller isolation)
        attr_reader     :owner

    public      # card owner is set by owner :)
        attr_writer     :owner

        attr_reader :name, :description, :legend
        attr_accessor :cost, :types, :colors, :abilities

        def initialize
            @name        = self.class.name
            @cost        = self.class.cost
            @colors      = self.class.colors.empty? ? @cost.colors : self.class.colors
            @types       = self.class.types
            @description = self.class.description
            @legend      = self.class.legend
            @abilities   = self.class.abilities

            @owner       = nil
        end

        def type
            @types.empty? ? "" : @types.first
        end

        def type?(type)
            @types.include?(type)
        end

        def color
            @cost ? @cost.color : :colorless
        end

        def color?(color)
            @colors.include?(color)
        end

        def permanent?
            is_a? Permanent
        end

        def has?( name )
            @abilities.include? name
        end
    end


    class Source < Card
    end
end
