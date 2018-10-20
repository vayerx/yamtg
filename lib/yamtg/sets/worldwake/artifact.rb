equipment 'Kitesail' do
    cost        2.colorless
    type        :Artifact

    ability :equip, 2.colorless do |_arena, card|
        abilities[:flying] = nil    # add ability to self
        card.power += 1
    end

    def unequip(arena, card)
        abilities.delete :flying    # remove ability from self
        card.power -= 1
        super
    end

    description <<-DECRIPTION_END.gsub(/\s+/, ' ').strip
        {U}, {T}: You may tap or untap another target creature.\n
        Landfall - Whenever a land enters the battlefield under your control,
        you may untap Tideforce Elemental.
    DECRIPTION_END

    legend 'Flavor: Ebb and flow, high tide and low, quick as sand and just as slow.'
end
