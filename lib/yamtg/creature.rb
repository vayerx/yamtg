require 'yamtg/permanent'

module YAMTG
    class Creature < Tapable
        # noinspection RubyClassVariableUsageInspection
        class << self
            %w[power toughness].each do |name|
                define_method(name) do |*val|
                    return class_variable_get('@@' + name) if val.empty?

                    class_variable_set('@@' + name, val.first)
                end
            end

            def init
                # noinspection RubySuperCallWithoutSuperclassInspection
                super
                class_variable_set :@@power, 0
                class_variable_set :@@toughness, 0
                class_variable_set :@@is_defender, false

                type :Creature
            end

            %w[defender].each do |name|
                define_method(name) { class_variable_set('@@is_' + name, true) }
            end
        end

        def initialize
            super
            @power     = unmodified_power
            @toughness = unmodified_toughness
        end

        attr_accessor :power, :toughness
        %w[power toughness].each do |name|
            define_method('unmodified_' + name) { self.class.send(:class_variable_get, '@@' + name) }
        end

        %w[defender].each do |name|
            define_method(name + '?') { self.class.send(:class_variable_get, '@@is_' + name) }
        end

        def can_attack?
            !tapped? && !defender?
        end

        def can_block?(card = nil)
            if card
                # TODO: {island,...}walk should be handled somewhere (battlefield required)
                return false if card.has? :unblockable
                return false if card.has?(:flying) && !(has?(:flying) || has?(:reach))
                return false if card.has?(:fear) && (!colors.include? :black)
            end
            !tapped?
        end

        def inspect
            ab = ability_names
            format('[%s]: %s %d/%d, %s', name, self.class.superclass.to_s.sub(/YAMTG::/, ''), power, toughness, color) +
                (ab.empty? ? '' : ' {' + ab.join(',') + '}') +
                ' ' + (tapped? ? 'tapped' : 'untapped')
        end
    end
end
