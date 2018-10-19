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
            %w[fear first_strike flying deathtouch lifelink reach vigilance].each do |name|
                define_method(name) { ability name.to_sym }
            end
        end

        attr_accessor :attachments

        def initialize
            @attachments = []       # cards (enchantments, equipments) attached to this card
            super
        end

        def has?(name)
            super || (@attachments.find { |card| card.has?(name) } != nil)
        end

        def ability_names
            (abilities.keys + @attachments.map { |card| card.abilities.keys }).uniq
        end

        def inspect
            format('[%s]: %s, %s', name, self.class.superclass.to_s.sub(/YAMTG::/, ''), color)
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
            raise 'Card is already tapped' if tapped?

            @tapped = true
            self
        end

        def untap
            raise 'Card is already untapped' unless tapped?

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
        # TODO: maybe inversion of abilities calling isn't a good idea
        def equip(arena, card)
            raise "Can't equip: #{card.inspect} isn't a creature" unless card.is_a? Creature

            action = abilities.fetch :equip
            card.owner.mana -= action[:cost] if card.owner      # TODO non-mana costs
            action[:action].call arena, card
            card.attach(self)
        end

        def unequip(_arena, card)
            card.detach(self)
        end
    end

    class Land < Tapable
        class << self
            def init
                # noinspection RubySuperCallWithoutSuperclassInspection
                super
                type :Land
            end
        end
    end
end
