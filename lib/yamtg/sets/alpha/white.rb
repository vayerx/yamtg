land 'Plains' do
    type        :Basic
    description '(Tap): Generate (W)'

    ability :tap_for_mana, :tap do |_arena, card|
        card.controller.add_mana(1.white)
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
creature 'Honeypot Plant' do
    cost        1.white, 1.colorless
    type        'Plant'
    toughness   4
    defender

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
