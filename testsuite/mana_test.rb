require 'yamtg/mana'
require 'test/unit'

class TestMana < Test::Unit::TestCase
    include YAMTG

    def test_colors
        assert_equal(:white, 1.white.color)
        assert_equal(:white, (1.white + 8000.colorless).color)
        assert_equal(:colorless, Mana.new.color)
        assert_equal(:colorless, 8000.colorless.color)
    end

    def test_calculation
        assert_equal(2, 2.black.total)
        assert_equal(5, (2.black + 3.red).total)
        assert_equal(1, (3.black - 2.colorless).total)
        assert_equal(0, (1.black - 1.black).total)
        assert_equal(0, (1.black - 1.colorless).total)
        assert_equal(1, ((1.red + 3.black) - 3.colorless).total)
        assert_equal(3, ((5.red + 3.black) - (2.colorless + 3.black)).total)
        assert_equal(3, ((5.red + 3.black) - (2.red + 3.black)).total)
        assert_equal(:red, ((3.red + 3.black) - (2.colorless + 3.black)).color)
        assert_raise(RuntimeError) { 1.black - 2.colorless }
        assert_raise(RuntimeError) { 1.colorless - 1.black }
        assert_raise(RuntimeError) { 1.red - 1.white }
    end

    def test_comparison
        assert(1.black == 1.black)
        assert(1.black < 2.black)
        assert(!(1.black < 1.black))
        assert(!(1.black > 1.black))
        assert(1.colorless < 1.black)       # can't subtract from colorless (TODO throw?)
        assert(!(1.colorless > 1.black))
    end
end
