#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2010, Vasiliy Yeremeyev <vayerx@gmail.com>,                   #
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

source "Mountain" do
    type        "Land"
    description "(Tap): Generate (R)"

    tap do |arena, card|
        card.owner.add_mana(1.red)
    end
end

creature "Dwarven Soldier" do
    cost    1.red
    type    "Dwarf"
    power       1
    toughness   2
end

creature "Mountain Ogre" do
    cost    1.red, 2.colorless
    type    "Ogre"
    power       3
    toughness   4
end

creature "Cave Troll" do
    cost    1.red, 2.colorless
    type    "Troll"
    power       2
    toughness   4
    description "(R): Cave Troll gains +4/-1 until end of turn"

    ability :anger, 1.red do
        @anger += 1
    end

    event :end_of_turn do |arena, card|
        card.anger -= 1 if card.anger > 0
    end

    attr_accessor :anger
    def initialize
        @anger = 0
    end
    def power
        @power+@anger*4
    end
    def toughness
        @toughness-@anger*1
    end
end

defender "Stonewall" do
    cost    1.red, 2.colorless
    type    "Wall"
    toughness 5

    description "(R)(R): Stonewall gains +3/0  until end of turn"
    legend      "The screams were unbearable when the defenders poured boiling oil over the attackers."

    ability :anger, 2.red do
        @anger += 1
    end

    event :end_of_turn do |arena, card|
        card.anger -= 1 if card.anger > 0
    end

    attr_accessor :anger
    def initialize
        @anger = 0
    end
    def toughness
        @toughness+@anger*3
    end
end
