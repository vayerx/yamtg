require 'yamtg/creature'

module YAMTG
    class CardSet
        #         def self.load(dir)
        #             # TODO
        #         end

        def initialize
            @cards = {}
        end

        def card(name)
            @cards.fetch name
        end

        %w[permanent instant sorcery creature land enchantment equipment].each do |type|
            define_method(type) do |name, &block|
                kobj = Class.new(eval(type.capitalize)) do
                    init
                    name(name)
                    class_eval(&block)
                end
                @cards[name] = kobj
                kobj
            end
        end
    end

    require 'singleton'
    class GlobalSets
        include Singleton

        def initialize
            @default = nil
            @sets = {}
        end

        def add(name)
            @default = @sets[name] = CardSet.new
        end

        def get(name)
            @sets.fetch name
        end

        attr_reader :default, :sets
    end

    %w[permanent instant sorcery creature land enchantment equipment].each do |type|
        define_method(type) { |name, &block| GlobalSets.instance.default.send(type, name, &block) }
    end

    def card_set(name)
        GlobalSets.instance.get name
    end

    def get_card_class(card_name, set_name = nil)
        return card_set(set_name).card(card_name) if set_name

        GlobalSets.instance.sets.each_value do |set|
            begin
                return set.card(card_name)
            rescue IndexError
                # ignored
            end
        end
        raise IndexError, "Card #{card_name} not found"
    end

    def get_card(card_name, set_name = nil)
        get_card_class(card_name, set_name).new
    end
end
