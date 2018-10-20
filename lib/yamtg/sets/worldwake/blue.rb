creature 'Tideforce Elemental' do
    cost        1.blue, 2.colorless
    type        :Elemental
    power       2
    toughness   1

    # ability 1.colorless, :tap do |arena, card|
    #     # TODO
    # end

    description <<-DECRIPTION_END.gsub(/\s+/, ' ').strip
        {U}, {T}: You may tap or untap another target creature.\n
        Landfall - Whenever a land enters the battlefield under your control,
        you may untap Tideforce Elemental.
    DECRIPTION_END

    legend 'Flavor: Ebb and flow, high tide and low, quick as sand and just as slow.'
end
