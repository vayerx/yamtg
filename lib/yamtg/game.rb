require 'yamtg/manipulator'
require 'yamtg/player'

module YAMTG
    class Game
        attr_reader :players

        def initialize
            @players = []
            @controllers = []
            @active_index = nil
        end

        def add_player(player, controller)
            @players << player
            controller.actor = Manipulator.new self, player
            @controllers << controller
        end

        def start_game(shuffle_cards = :shuffle)
            raise "Can't start game -- no players" if @players.empty?

            @active_index = 0
            @players.each { |player| player.deck.shuffle! } if shuffle_cards == :shuffle
            @players.each { |player| player.draw 7 }
        end

        def next_round
            raise 'Game over' if game_over?

            do_player_step(*active_player)
            next_player
        end

        def game_over?
            raise 'No players' if @players.empty?

            @players.all?(&:dead?)
        end

    private

        def active_player   # TODO: rename/split - return controller
            raise "No active player -- game hasn't started" if @active_index.nil?

            [@controllers.fetch(@active_index), @players.fetch(@active_index)]
        end

        def next_player
            return @active_index = nil if game_over?
            while @players[@active_index].dead? do
                @active_index = (@active_index + 1) % @players.size
            end
            true
        end

        def do_player_step(controller, player)
            controller.on_untap_step
            controller.on_upkeep_step
            controller.on_draw_step

            controller.on_first_main_phase

            controller.on_beginning_of_combat_step
            controller.on_declare_attackers_step
            controller.on_declare_blockers_step
            controller.on_combat_damage_step
            controller.on_end_of_combat_step

            controller.on_end_step

            # cleanup step
            if player.hand.size > player.max_hand_size
                excessive = player.hand.size - player.max_hand_size
                range = controller.on_discard_cards excessive
                raise "Discarded #{range.count} cards instead of #{excessive}" if range.count != excessive

                player.discard range
            end
        end
    end
end
