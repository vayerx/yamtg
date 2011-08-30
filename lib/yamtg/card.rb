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
            %w[name types colors description legend].each { |name|
                define_method( name ) { |*val|
                    return class_variable_get( '@@' + name ) if val.empty?
                    class_variable_set( '@@' + name, val.first )
                }
            }

            def inherited( subclass )
                subclass.init
            end

            def init
                cost          Mana.new
                types         []
                colors        []
                description   ""
                legend        ""
            end

            def cost( *mana )
                class_variable_set :@@cost, mana.inject( Mana.new ) { |a, b| a + b }
            end

            def type( name )
                types( class_variable_get( :@@types ) << name )
            end

            def ability( *val )
                # TODO
            end
            def tap ( *val, &descr )
                # TODO
            end
            def event( *val )
                # TODO
            end
        end

        %w[name cost types colors description legend].each { |name|
            define_method( name ) { |*val|
                return instance_variable_get( '@' + name ) if val.empty?
                instance_variable_set( '@' + name, val.first )
            }

        }

        attr_reader     :owner

        def initialize
            @name        = self.class.name
            @cost        = self.class.cost
            @colors      = self.class.colors.empty? ? @cost.colors : self.class.colors
            @types       = self.class.types
            @description = self.class.description
            @legend      = self.class.legend

            @tapped       = false
            @attachements = []    # cards (enchantments, equipments) attached to this card
            # @tokens       = Hash.new(0)
        end

        def class?(klass)
            @class == klass
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

        def tapped?
            @tapped
        end

        def attach(card)
            @attachements << card
        end

        def detach(card)
            @attachements.delete(card)
        end

        def inspect
            "[%s]: %s %s" % [ name, self.class.superclass.to_s.sub( /YAMTG::/, ''), color ]
        end
    end

    class Source < Card
    end
end
