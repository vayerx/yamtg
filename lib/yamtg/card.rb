require 'yamtg/mana'

module YAMTG
    class Card
        # noinspection RubyClassVariableUsageInspection
        class << self
            # TODO: subtypes
            %w[name types colors description legend abilities].each do |name|
                define_method(name) do |*val|
                    return class_variable_get('@@' + name) if val.empty?

                    class_variable_set('@@' + name, val.first)
                end
            end

            def init
                class_variable_set :@@name, ''
                class_variable_set :@@cost, Mana.new
                class_variable_set :@@types, []
                class_variable_set :@@colors, []
                class_variable_set :@@description, ''
                class_variable_set :@@legend, ''
                class_variable_set :@@abilities, {}
            end

            def artifact
                types :artifact
            end

            def cost(*mana)
                return class_variable_get(:@@cost) if mana.empty?

                class_variable_set(:@@cost, mana.inject(Mana.new) { |a, b| a + b })
            end

            def type(*name)
                return types if name.empty?

                types(types.concat(name))
            end

            def ability(name, *cost, &action)
                abilities[name] = block_given? ? { cost: cost, action: Proc.new(&action) } : { cost: cost }
            end

            def tap(*val, &descr)
                # TODO
            end

            def event(*val)
                # TODO
            end
        end

        attr_accessor :owner, :controller
        attr_reader :name, :description, :legend
        attr_accessor :cost, :types, :colors, :abilities

        def initialize
            @name        = self.class.name
            @cost        = self.class.cost
            @colors      = self.class.colors.empty? ? @cost.colors : self.class.colors
            @types       = self.class.types
            @description = self.class.description
            @legend      = self.class.legend
            @abilities   = self.class.abilities
            @owner       = nil
        end

        def type
            @types.empty? ? '' : @types.first
        end

        def type?(type)
            @types.include?(type)
        end

        def color
            @cost ? @cost.color : :colorless
        end

        def color?(color)
            @colors.include?(color)
        end

        def permanent?
            is_a? Permanent
        end

        def has?(name)
            @abilities.include? name
        end
    end

    class Sorcery < Card
    end

    class Instant < Card
    end
end
