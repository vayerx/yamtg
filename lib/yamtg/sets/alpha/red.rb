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

    event :end_of_turn do |_arena, card|
        card.anger = 0
    end

    def initialize
        @anger = 0
        super
    end

    def power
        unmodified_power + @anger * 4
    end

    def toughness
        unmodified_toughness - @anger * 1
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

    event :end_of_turn do |_arena, card|
        card.anger -= 1 if card.anger > 0
    end

    def initialize
        @anger = 0
        super
    end

    def power
        unmodified_power + @anger * 3
    end

    def inspect
        "#{super}, anger: #{@anger}"
    end
end
