require 'yamtg/sets/alpha'
require 'yamtg/ai/dummy_one'
require 'yamtg/game'
require 'test/unit'
require 'pp'

class TestAiDummyOne < Test::Unit::TestCase
    include YAMTG

    def setup
        @game = Game.new
        @player1 = Player.new 'Player1'
        @game.add_player @player1, AiDummyOne.new
    end

    def test_basics
        @player1.deck(['Mountain', 2, 'Dwarven Soldier', 4, 'Mountain', 2, 'Cave Troll', 4])
        @game.start_game :dont_shuffle
        assert(@player1.battlefield.empty?)

        # playing land
        @game.next_round
        assert_equal(2, @player1.battlefield.length)
        assert_equal('Mountain', @player1.battlefield.first.name)
    end
end
