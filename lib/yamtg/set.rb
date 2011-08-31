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

        # create a new class subclassing YAMTG::Source
        def source( name, &desc )
            src = Class.new( Source ) {
                name(name)
                class_eval( &desc )
            }
            @cards[ name ] = src
            src
        end

        # create a new class subclassing YAMTG::Creature
        def creature( name, &desc )
            mon = Class.new( Creature ) {
                name( name )
                class_eval( &desc )
            }
            @cards[ name ] = mon
            mon
        end

        # create a new class subclassing YAMTG::Defender
        def defender( name, &desc )
            mon = Class.new( Defender ) {
                name( name )
                class_eval( &desc )
            }
            @cards[ name ] = mon
            mon
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


    # create a new class subclassing YAMTG::Source
    def source( name, &desc )
        GlobalSets.instance.default.source( name, &desc )
    end

    # create a new class subclassing YAMTG::Creature
    def creature( name, &desc )
        GlobalSets.instance.default.creature( name, &desc )
    end

    # create a new class subclassing YAMTG::Defender
    def defender( name, &desc )
        GlobalSets.instance.default.defender( name, &desc )
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
            end
        end
        raise IndexError, "Card #{card_name} not found"
    end

    def get_card( card_name, set_name = nil )
        get_card_class( card_name, set_name ).new
    end
end
