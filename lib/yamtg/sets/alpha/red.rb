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

land 'Mountain' do
    type        :Basic
    description '(Tap): Generate (R)'

    ability :tap_for_mana, :tap do |_arena, card|
        card.controller.add_mana(1.red)
    end
end

creature 'Dwarven Soldier' do
    cost        1.red
    type        :Dwarf
    power       1
    toughness   2
end

creature 'Mountain Ogre' do
    cost        1.red, 2.colorless
    type        :Ogre
    power       3
    toughness   4
end

creature 'Cave Troll' do
    cost        1.red, 2.colorless
    type        :Troll
    power       2
    toughness   4

    description '(R): Cave Troll gains +4/-1 until end of turn'

    attr_accessor :anger

    ability :anger, 1.red do
        @anger += 1
    end

    event :end_of_turn do |arena, card|
        card.anger = 0
    end

    def initialize
        @anger = 0
        super
    end

    def power
        unmodified_power + @anger*4
    end

    def toughness
        unmodified_toughness - @anger*1
    end

    def inspect
        "#{super}, anger: #{@anger}"
    end
end

creature 'Stonewall' do
    cost        1.red, 2.colorless
    type        :Wall
    toughness   5
    defender

    description '(R)(R): Stonewall gains +3/0  until end of turn'
    legend      'The screams were unbearable when the defenders poured boiling oil over the attackers.'

    attr_accessor :anger

    ability :anger, 2.red do
        @anger += 1
    end

    event :end_of_turn do |arena, card|
        card.anger -= 1 if card.anger > 0
    end

    def initialize
        @anger = 0
        super
    end

    def power
        unmodified_power + @anger*3
    end

    def inspect
        "#{super}, anger: #{@anger}"
    end
end
