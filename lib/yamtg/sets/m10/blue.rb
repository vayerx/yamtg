creature 'Air Elemental' do
    cost        2.blue, 3.colorless
    type        :Elemental
    power       4
    toughness   4

    flying
end

creature 'Alluring Siren' do
    cost        1.blue, 1.colorless
    type        :Siren
    power       1
    toughness   1

    description '{T}: Target creature an opponent controls attacks you this turn if able.'

    legend <<-LEGEND_END.gsub(/\s+/, ' ').strip
        'The ground polluted floats with human gore,\nAnd human carnage taints the dreadful shore\n
         Fly swift the dangerous coast: let every ear\nBe stopp'd against the song! 'tis death to hear!'\n
         -Homer, The Odyssey, trans. Pope
    LEGEND_END
end

creature 'Clone' do
    cost        1.blue, 3.colorless
    type        :Shapeshifter
    power       0
    toughness   0

    legend      'The shapeshifter mimics with a twinab\'s esteem and a mirror\'s cruelty.'
end

creature 'Djinn of Wishes' do
    cost        2.blue, 3.colorless
    type        :Elemental
    power       4
    toughness   4

    flying

    description <<-DESC_END.gsub(/\s+/, ' ').strip
        {M}{M}{B}{B}: ...Reveal the top card of your library.
        You may play this card without paying its mana cost...
    DESC_END
end

enchantment 'Convincing Mirage' do
    cost        1.blue, 1.colorless
    type        :Aura
end
