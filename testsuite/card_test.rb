require 'yamtg/sets/sets'
require 'test/unit'
require 'pp'

unless defined? KeyError # ruby 1.8
    class KeyError < StandardError
    end
end

class TestCore < Test::Unit::TestCase
    include YAMTG

    def new_card(name, klass = Card)
        card = get_card name
        assert(card && card.is_a?(klass))
        assert_equal(name, card.name)
        card
    end

    def test_invalid
        alpha = card_set 'Alpha'
        assert_raise(KeyError) do
            begin
                alpha.card('invalid-CARD-name')
            rescue IndexError       # ruby 1.8
                raise KeyError
            end
        end
    end

    def test_autofetcher
        assert_nothing_raised do
            YAMTG.get_card 'Cloud Phantom'
            YAMTG.get_card 'Cloud Phantom', 'Alpha'
        end
        assert_raise(KeyError) do
            begin
                YAMTG.get_card 'Cloud Phantom', 'invalid-SET-name'
            rescue IndexError       # ruby 1.8
                raise KeyError
            end
        end
    end

    def test_phantom
        card = new_card 'Cloud Phantom', Creature
        assert_equal(:Creature, card.type)
        assert(card.type?(:Illusion))
        assert(!card.type?(:NotIllusion))
        assert(card.permanent?)
        assert_equal(:black, card.color)
        assert_equal(3, card.cost.total)
        assert_equal(3, card.power)
        assert_equal(5, card.toughness)
    end

    # independent attributes (compared with Cloud Phantom)
    def test_zephyr
        card = new_card 'Zephyr of the sky', Creature
        assert_equal(:Creature, card.type)
        assert(card.type?(:Bird))
        assert_equal(:blue, card.color)
        assert_equal(3, card.cost.total)
        assert_equal(3, card.power)
        assert_equal(1, card.toughness)
        assert(card.can_attack?)
        assert(card.has?(:vigilance))
        assert(!card.has?(:first_strike))
    end

    sorcery 'Duress' do
        cost        1.black
        description 'Target opponent reveals his or her hand...'
    end

    # Sorcery
    def test_duress
        card = new_card 'Duress', Sorcery
        assert(!card.permanent?)
        assert_equal(:black, card.color)
        assert_equal(1, card.cost.total)
    end

    # only instance variables should be modified on card manipulation
    def test_modification
        card1 = new_card 'Zephyr of the sky'
        assert_equal(3, card1.power)
        card1.power = 1
        assert_equal(1, card1.power)

        card2 = new_card 'Zephyr of the sky'
        assert_equal(3, card2.power)
    end

    # "dynamic" attributes
    def test_stonewall
        card = new_card 'Stonewall', Creature
        assert(!card.can_attack?)
        assert(card.defender?)
        assert_equal(0, card.power)         # initial power (isn't defined in spec)
        assert_equal(0, card.anger)         # initial anger (card-specific)
        card.anger = 1
        assert_equal(3, card.power)         # modified power
    end
end
