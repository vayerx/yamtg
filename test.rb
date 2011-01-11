#!/usr/bin/env ruby
#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2010, Vasiliy Yeremeyev <vayerx@gmail.com>.                   #
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

# ---------------------------------------------------------------------------
class Card
    class << self
        def name( val )
            self.send( :class_variable_set, :@@card_name, val )
        end
    end

    def name
        self.class.send( :class_variable_get, :@@card_name )
    end
end

# ---------------------------------------------------------------------------
class Creature < Card
    class << self
        def inherited(by)
            super
        end

        # def card_const( name )
            # define_method( name, class_variable_set :@@power, val
        # end
        def power( val )
            class_variable_set :@@power, val
        end
        def toughness( val )
            class_variable_set :@@toughness, val
        end
    end

    def initialize
        super
        @power     = unmodified_power
        @toughness = unmodified_toughness
    end

    def power( val = nil )
        return @power if !val
        @power = val
    end

    def toughness( val = nil )
        return @toughness if !val
        @toughness = val
    end

    def unmodified_power
        self.class.send( :class_variable_get, :@@power )
    end

    def unmodified_toughness
        self.class.send( :class_variable_get, :@@toughness )
    end


    def inspect
        "[%s]: %s %d/%d" % [ name, self.class.superclass, power, toughness ]
    end
end

# ---------------------------------------------------------------------------
class CardSet
    def initialize
        @cards = Hash.new
    end

    attr_reader :cards

    def creature( a_name, &a_desc )
        res = Class.new( Creature ) {
            name( a_name )
        }
        res.class_eval( &a_desc )
        @cards[ a_name ] = res
        res
    end
end

# ---------------------------------------------------------------------------
class AlphaSet < CardSet
    def initialize
        super

        creature "Air Elemental" do
            power       4
            toughness   4
        end

        creature "Dead Rat" do
            power       1
            toughness   2
        end

        creature "Gargoyle" do
            power       2
            toughness   2
        end
    end
end

# ---------------------------------------------------------------------------
cards = AlphaSet.new

rat_factory = cards.cards[ "Dead Rat" ]
#puts "rat_factory=#{rat_factory}/#{rat_factory.class}"

dead_rat = rat_factory.new
#puts "dead_rat: in=#{dead_rat.instance_variables}  cl=#{dead_rat.class.class_variables}"
puts "dead_rat = #{dead_rat.inspect}"
puts "air elem = #{cards.cards[ "Air Elemental" ].new.inspect}"
puts "gargoyle = #{cards.cards[ "Gargoyle" ].new.inspect}"
