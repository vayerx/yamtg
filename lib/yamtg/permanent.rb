require 'yamtg/card'

module YAMTG
    class Permanent < Card
        class << self
            %w[fear first_strike flying deathtouch lifelink reach vigilance].each do |name|
                define_method(name) { ability name.to_sym }
            end
        end

        attr_accessor :attachments

        def initialize
            @attachments = []       # cards (enchantments, equipments) attached to this card
            super
        end

        def has?(name)
            super || (@attachments.find { |card| card.has?(name) } != nil)
        end

        def ability_names
            (abilities.keys + @attachments.map { |card| card.abilities.keys }).uniq
        end

        def inspect
            format('[%s]: %s, %s', name, self.class.superclass.to_s.sub(/YAMTG::/, ''), color)
        end
    end

    class Tapable < Permanent
        def initialize
            super
            @tapped = false
        end

        def tapped?
            @tapped
        end

        def tap
            raise 'Card is already tapped' if tapped?

            @tapped = true
            self
        end

        def untap
            raise 'Card is already untapped' unless tapped?

            @tapped = false
            self
        end

        def attach(card)
            @attachments << card
        end

        def detach(card)
            @attachments.delete(card)
        end
    end

    class Enchantment < Permanent
    end

    class Equipment < Permanent
        # TODO: maybe inversion of abilities calling isn't a good idea
        def equip(arena, card)
            raise "Can't equip: #{card.inspect} isn't a creature" unless card.is_a? Creature

            action = abilities.fetch :equip
            card.owner.mana -= action[:cost] if card.owner      # TODO non-mana costs
            action[:action].call arena, card
            card.attach(self)
        end

        def unequip(_arena, card)
            card.detach(self)
        end
    end

    class Land < Tapable
        class << self
            def init
                # noinspection RubySuperCallWithoutSuperclassInspection
                super
                type :Land
            end
        end
    end
end
