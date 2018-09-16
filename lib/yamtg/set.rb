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

require 'yamtg/creature'

module YAMTG
    class CardSet
#         def self.load(dir)
#             # TODO
#         end

        def initialize
            @cards = Hash.new
        end

        def card( name )
            @cards.fetch name
        end

        %w[permanent source creature defender land enchantment equipment].each do |type|
            define_method( type ) { |name, &block|
                kobj = Class.new( eval type.capitalize ) {
                    init
                    name(name)
                    class_eval( &block )
                }
                @cards[ name ] = kobj
                kobj
            }
        end
    end


    require 'singleton'
    class GlobalSets
        include Singleton

        def initialize
            @default = nil
            @sets = {}
        end

        def add( name )
            @default = @sets[name] = CardSet.new
        end

        def get( name )
            @sets.fetch name
        end

        attr_reader :default, :sets
    end

    %w[permanent source creature defender land enchantment equipment].each do |type|
        define_method( type ) { |name, &block| GlobalSets.instance.default.send( type, name, &block ) }
    end

    def card_set( name )
        GlobalSets.instance.get name
    end

    def get_card_class( card_name, set_name = nil )
        return card_set( set_name ).card( card_name ) if set_name
        GlobalSets.instance.sets.each_value do |set|
            begin
                return set.card( card_name )
            rescue IndexError
                # ignored
            end
        end
        raise IndexError, "Card #{card_name} not found"
    end

    def get_card( card_name, set_name = nil )
        get_card_class( card_name, set_name ).new
    end
end
