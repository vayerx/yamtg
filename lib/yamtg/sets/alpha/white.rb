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

land 'Plains' do
    type        :Land
    description '(Tap): Generate (W)'

    tap do |arena, card|
        card.owner.add_mana(1.white)
    end
end

# Rather cheap flying attacker
creature 'Pegasus' do
    cost        2.white
    type        :Animal
    power       2
    toughness   2

    flying
    first_strike
end

# Weak Blocker type, but at least it's tough and can be eaten
defender 'Honeypot Plant' do
    cost        1.white, 1.colorless
    type        'Plant'
    toughness   4

    description '(Tap): Sacrifice to gain 5 life'
    legend   'These plants were created by the great magicians to endure lasting sieges.'

    tap do |arena, card|
        arena.destroy(card)
        card.owner.life += 5
    end
end

creature 'Lancer of the Sacred Rose' do
    cost        1.white
    type        :Knight
    power       1
    toughness   1

    first_strike
end

# Decent fighter.
creature 'Knight of the Sacred Rose' do
    cost        2.white, 1.colorless
    type        :Knight
    power       5
    toughness   4

    first_strike

    legend 'Honour is my life.'

end


# Also a decent fighter but got a big horse as his mount, so has
# a higher offense power while retaining first strike.
creature 'Rider of the Sacred Rose' do
    cost        2.white, 2.colorless
    type        :Knight

    power       5
    toughness   3

    first_strike
end

# Expensive big creature for late-game.
creature 'Paladin of the Sacred Rose' do
    cost        3.white, 3.colorless
    type        :Paladin

    power       6
    toughness   4

    first_strike

    description '(Tap)(W): Prevent any target from 2 damage'
    legend      'Honour your friends.'

    tap 1.white do |arena, card|
        # prevent 2 damage dealt to any target, the damage is dealt to
        # paladin of the sacred rose
        # card.owner.pick_damageable_target.intercept(:receiving_damage) do |modifier, arena2, target, params|
        #     params.effective_damage -= 2
        #     card.damage(100)
        #   modifier.remove
        # end
    end
end
