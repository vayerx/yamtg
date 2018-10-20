require 'yamtg/sets/sets'
require 'yamtg/controller'
require 'yamtg/game'
require 'test/unit'
require 'pp'

class TestGame < Test::Unit::TestCase
    include YAMTG

    creature 'Ezuri\'s Archers' do
        cost        1.green
        power       1
        toughness   2
        reach
    end

    permanent 'Fear' do
        cost        2.black
        type        :Aura
        description 'Enchant creature. Enchanted creature has fear.'
        fear # hack?
    end

    def setup
        @game = Game.new

        @gargoyle = get_card 'Gargoyle'         # 2/2, flying
        @pegasus  = get_card 'Pegasus'          # 2/2, flying, first strike
        @archers  = get_card 'Ezuri\'s Archers' # 1/2, reach
        @phantom  = get_card 'Cloud Phantom'    # 3/5
        @fear     = get_card 'Fear'             # enchantment - aura
        @kitesail = get_card 'Kitesail'         # artifact equipment
    end

    def test_discard_excessive_cards
        player = Player.new 'Player'
        player.deck(['Dwarven Soldier', 1, 'Cave Troll', 4, 'Mountain Ogre', 4])
        @game.add_player player, Controller.new

        @game.start_game shuffle_cards = :DoNotShuffle
        assert(player.graveyard.empty?)
        @game.next_round # 8 cards - 1 card should be discarded
        assert(!player.graveyard.empty?)
        assert_equal('Dwarven Soldier', player.graveyard.first.name)
    end

    def test_basic_blocking_abilities
        assert(@gargoyle.can_attack? && @pegasus.can_attack? && @phantom.can_attack? && @archers.can_attack?)
        assert(@gargoyle.can_block? && @pegasus.can_block? && @phantom.can_block? && @archers.can_block?)
        assert(@gargoyle.can_block?(@pegasus))     # flying - flying
        assert(@gargoyle.can_block?(@phantom))     # flying - basic
        assert(!@phantom.can_block?(@gargoyle)) # basic - flying
        assert(@phantom.can_block?(@archers)) # basic - basic

        @phantom.tap
        assert(!@phantom.can_block?(@archers)) # basic tapped - basic
        assert(!@phantom.can_attack? && !@phantom.can_block?)
    end

    def test_enchanted_cards
        assert(@archers.can_block?(@phantom)) # basic - basic
        assert(!@phantom.has?(:fear))
        assert(@fear.has?(:fear))
        @phantom.attach @fear
        assert(@phantom.has?(:fear))
        assert(!@archers.can_block?(@phantom)) # basic with fear - basic
    end

    def test_equipped_cards
        assert(!@phantom.has?(:flying))
        assert_equal(3, @phantom.power)
        @kitesail.equip nil, @phantom
        assert(@phantom.has?(:flying))
        assert_equal(4, @phantom.power)
        @kitesail.unequip nil, @phantom
        assert(!@phantom.has?(:flying))
        assert_equal(3, @phantom.power)
    end

    # Equipment detachment shouldn't remove "native" attributes
    def test_equipment_removal
        assert(@gargoyle.has?(:flying))
        @kitesail.equip nil, @gargoyle # @gargoyle now has "double" flying
        assert(@gargoyle.has?(:flying))
        @kitesail.unequip nil, @gargoyle
        assert(@gargoyle.has?(:flying))
    end

    def test_basic_damage_abilities
        # TODO
    end
end
