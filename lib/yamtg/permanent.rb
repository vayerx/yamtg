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
    class Permanent < Card
        class << self
            %w[fear first_strike flying deathtouch lifelink reach vigilance].each { |name|
                define_method( name ) { ability name.to_sym }
            }
        end

        attr_accessor :attachments

        def initialize
            @attachments = []       # cards (enchantments, equipments) attached to this card
            super
        end

        def has?( name )
            super or @attachments.find { |card| card.abilities.include? name } != nil
        end

        def ability_names
            (abilities.keys + @attachments.map { |card| card.abilities.keys } ).uniq
        end

        def inspect
            "[%s]: %s, %s" % [ name, self.class.superclass.to_s.sub( /YAMTG::/, ''), color ]
        end
    end

    class Tapable < Permanent
        def initialize
            super
            @tapped = false
        end

        def tapped?
            @tapped
        end

        def tap
            raise RuntimeError, "Card is already tapped" if tapped?
            @tapped = true
            self
        end

        def untap
            raise RuntimeError, "Card is already untapped" if not tapped?
            @tapped = false
            self
        end

        def attach(card)
            @attachments << card
        end

        def detach(card)
            @attachments.delete(card)
        end
    end


    class Enchantment < Permanent
    end


    class Equipment < Permanent
        def equip( card )
            raise RuntimeError, "Can't equip: #{card.inspect} isn't a creature" if !card.is_a? Creature
            card.attach( self )
        end

        def unequip( card )
            card.detach( self )
        end
    end


    class Land < Tapable
    end
end
