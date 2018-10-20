creature 'Zephyr of the sky' do
    cost        1.blue, 2.colorless
    type        :Bird   # or Animals/Bird or just Bird?
    power       3
    toughness   1

    vigilance   # attacking does not cause him to tap

    ability :shield, 1.white, :tap do
        description 'Prevent two damage to any target.'
    end
end


creature 'Blue Knight of Deceit' do
    cost        2.blue
    type        :Knight
    power       2
    toughness   2

    first_strike

    description '(B): Blue Knight of Deceit changes his colors to a color of your choice, this change is permanent.'

    #ability 1.blue do
    #
    #end
end


creature 'Tyrant of the Deep' do
    cost        3.blue, 2.colorless
    type        :Human
    power       2
    toughness   4

    legend  'The tyrants of the deep were skilled but expensive mercenaries that were
            able to destroy enemy units with great ease - if they had enough time to
            invoke their wicked magic.'

    tap 3.blue do
        description 'Destroy target tapped permanent. Use this ability only during your turn.'
    end
end


# Wizard that helps to untap permanents
creature 'Emergency Wizard' do
    cost        2.blue
    type        :Human
    power       0
    toughness   2

    legend  'The Emergency Wizards were useful to return battle units to home quickly.'

    tap 1.blue do
        description 'Untap target permanent you control.'
    end
end


creature 'Deep Sea Underground Oracle' do
    cost        4.blue, 6.colorless
    # TODO type: Dunno... energy thing?
    power       0
    toughness   14

    description 'When this card comes into play, draw 2 cards\n' \
                '(Tap): Draw 2 cards'
    legend 'The Oracle was a difficult place to reach, but once ' \
           'someone found it, it was a place for wisdom and knowledge.'

    event :comes_into_play do |_arena, card|
        card.owner.takeup(2)
    end

    # tap it to draw 2 cards
    tap do |_arena, card|
        card.owner.takeup(2)
    end
end
