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

source "Swamp" do
    type        "Land"
    description "(Tap): Generate (K)"

#     tap do |arena, card|
#         card.owner.add_mana(1.black)
#     end
end

defender "Tarpit" do
    cost        1.black, 1.colorless
    type        "Trap"
    power       0
    toughness   4

    description "(K)(K): When blocking, destroy the blocked card, the card still deals the damage"
    legend <<-LEGEND_END.gsub(/\s+/, " ").strip
         It was his last mistake not to watch his step, and the more he tried to free himself,
         the deeper he sank into the undefinable black fluid.
    LEGEND_END

#     ability :drown, 2.black do |arena, card|
#         raise InvalidTiming unless card.blocking?
#         destroy = if card.blocking.length > 1 then
#             card.owner.pick_card(card.blocking)
#         else
#             card.blocking.first
#         end
#         arena.destroy(card, :end_of_turn)
#     end
end

creature "Dead Rat" do
    cost        1.black
    type        "Zombie"
    power       1
    toughness   1

    description "(K): Regenerate"

    ability :regenerate, 1.black do |arena, card|
        arena.regenerate(card)
    end
end

creature "Bat" do
    cost        1.black
    type        "Animal"
    flying

    power       1
    toughness   1
end

creature "Gargoyle" do
    cost        2.black
    type        "Creature"
    flying

    power       2
    toughness   2

    description "(K): Turn gargoyle into 0/4 non-flying artefact until end of turn."
    legend      "Stone at day, murdering beast at night."

    ability :morph, 1.black do |arena, card|
        card.morph(true)
    end
    event :end_of_turn do |arena, card|
        card.morph(false)
    end

    def morph(to_artefact)
        if to_artefact then
            @power      = 0
            @toughness  = 4
            @flags      = []
        else
            @power      = 2
            @toughness  = 2
            @flags      = [:flying]
        end
    end
end

creature "Cloud Phantom" do
    cost        2.black, 1.colorless
    type        "Illusion"
    power       3
    toughness   5
end
