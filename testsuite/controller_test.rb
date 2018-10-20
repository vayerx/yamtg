require 'yamtg/sets/alpha'
require 'yamtg/controller'
require 'yamtg/game'
require 'test/unit'
require 'pp'

class TestController < Test::Unit::TestCase
    include YAMTG

    def setup
        @game = Game.new
        @player1 = Player.new 'Player1'
        @game.add_player @player1, Controller.new
    end

    def test_untapping
        @player1.deck('Mountain' => 20)
        @game.start_game

        assert(@player1.battlefield.empty?)
        @player1.battlefield << get_card('Dwarven Soldier').tap
        assert(@player1.battlefield.first.tapped?)

        @game.next_round
        assert(!@player1.battlefield.first.tapped?)
    end
end
