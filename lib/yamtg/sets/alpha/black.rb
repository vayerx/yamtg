land 'Swamp' do
    type        :Basic
    description '(Tap): Generate (K)'

    ability :tap_for_mana, :tap do |_arena, card|
        card.controller.add_mana(1.black)
    end
end

creature 'Tarpit' do
    cost        1.black, 1.colorless
    type        :Trap
    power       0
    toughness   4
    defender

    description '(K)(K): When blocking, destroy the blocked card, the card still deals the damage'
    legend <<-LEGEND_END.gsub(/\s+/, ' ').strip
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

creature 'Dead Rat' do
    cost        1.black
    type        :Zombie
    power       1
    toughness   1

    description '(K): Regenerate'

    ability :regenerate, 1.black do |arena, card|
        arena.regenerate(card)
    end
end

creature 'Bat' do
    cost        1.black
    type        :Animal
    power       1
    toughness   1

    flying
end

creature 'Gargoyle' do
    cost        2.black
    power       2
    toughness   2

    flying

    description '(K): Turn gargoyle into 0/4 non-flying artifact until end of turn.'
    legend      'Stone at day, murdering beast at night.'

    ability :morph, 1.black do |_arena, card|
        card.morph(true)
    end
    event :end_of_turn do |_arena, card|
        card.morph(false)
    end

    def morph(to_artifact)
        if to_artifact
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

creature 'Cloud Phantom' do
    cost        2.black, 1.colorless
    type        :Illusion
    power       3
    toughness   5
end
