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

require 'yamtg/card'

module YAMTG
    class Creature < Card
        class << self
            def inherited(by)
                super
                by.power 0
                by.toughness 0
            end

            def power( value ); @power = value; end
            # def power=( value ); @power = value; end
            # def power;           @power != Nil ? @power : @@power; end

            def toughness( value ); @toughness = value; end
            # def toughness= ( value );   @toughness = value; end
            # def toughness;              @toughness != Nil ? @toughness : @@toughness; end
        end

        def unmodified_power;        @@power;        end
        def unmodified_toughness;    @@toughness;    end

        def initialize( *params )
            super( *params )
            puts "CRATURE(#{self}/#{self.class}) in=#{instance_variables}  cl=#{self.class.class_variables}"
            puts "#{@name}"
        end

        def can_attack?
            !tapped?
        end

        def can_defend?
            !tapped?
        end
    end

    class Defender < Creature
        def can_attack?
            false
        end
    end
end
