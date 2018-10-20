require 'set'

module YAMTG
    class Mana
        Colors = %i[red green blue black white colorless].freeze
        Chars  = { red: 'R', green: 'G', blue: 'B', black: 'K', white: 'W' }.freeze

        class << self
            def self.sort(colors)
                colors.sort_by { |color| Colors.index(color) }
            end
        end

        attr_reader :amount     # color pairs
        attr_reader :total      # total amount
        attr_reader :colors     # colors set (TODO excessive value)

        def initialize(mana = {})
            @amount = Hash[*mana.map { |k, v| Array === k ? [Mana.sort(k), v] : [k, v] }.flatten]
            @amount.reject! { |k, v| k != :infinite && v.zero? }
            @amount.freeze
            @total  = @amount.values.inject(0) { |a, b| String === b ? a : a + b }
            @colors = @amount.keys.each_with_object(Set.new) { |color, res| res << color if color != :colorless; }
            @colors = [:colorless] if @colors.empty?
        end

        def [](key)
            @amount[Array === key ? Mana.sort(key) : key] || 0
        end

        def +(other)
            Mana.new(@amount.merge(other.amount) { |_key, a, b| a + b })
        end

        def -(other)
            raise "Don't know how to subtract #{other.class} from Mana" unless other.is_a? Mana
            raise 'Colorless mana detected!' if @amount.include? :colorless

            new = @amount.dup
            # exact matching
            other.amount.each do |color, amount|
                next unless color != :colorless

                value = new[color]
                raise "Not enough #{color} mana: #{value} < #{amount}" if !value || (value < amount)

                value > amount ? new[color] -= amount : new.delete(color)
            end

            # handle colorless
            colorless = other.amount[:colorless]
            if colorless
                new.delete_if do |color, amount|
                    colorless -= (value = [colorless, amount].min)
                    (new[color] -= value) == 0
                end
                raise 'Oops, not enough mana to subtract colorless' if colorless != 0
            end
            Mana.new(new)
        end

        def <(other)
            # TODO: optimize
            !(self - other).zero?
        rescue StandardError
            true
        end

        def >(other)
            other < self
        end

        def ==(other)
            return false if (other.amount != @amount) || (other.total != @total)

            other.amount.each { |color, amount| return false if @amount[color].nil? || (@amount[color] != amount) }
        end

        def color
            @colors.size == 1 ? @colors.first : :multicolor
        end

        # returns the colors that are negative if there are any
        def negative?
            found = @amount.reject { |_k, v| !(String === v) && v >= 0 }
            found.empty? ? false : found.keys
        end

        def zero?
            @amount.empty?
        end

        def infer_color
            k = @amount.keys - %i[colorless infinite]
            if k.empty?
                :artifact
            else
                k.grep(Array).empty? && k.length == 1 ? k.first : :multicolor
            end
        end

        # can't print negative mana
        def to_s(x = false)
            a         = @amount.reject { |_k, v| !(String === v) && v < 1 }
            colorless = a[:colorless] ? ["(#{a.delete(:colorless)})"] : []
            infinite  = a[:infinite] ? ["(#{a.delete(:infinite).split(//).sort.join(')(')})"] : []
            if x
                monocolor  = Mana::Colors.map { |color| "#{a.delete(color)}x(#{Mana::Chars[color]})" if a[color] }.compact
                multicolor = a.map { |k, v| "#{v}x(#{k.map { |color| Mana::Chars[color] }.join('/')})" }
                (multicolor + monocolor + colorless + infinite).join(', ')
            else
                monocolor  = Mana::Colors.map { |color| "(#{Mana::Chars[color]})" * a.delete(color) if a[color] }.compact
                multicolor = a.map { |k, v| "(#{k.map { |color| Mana::Chars[color] }.join('/')})" * v }
                (multicolor + monocolor + colorless + infinite).join('')
            end
        end

        def inspect
            if @amount.empty?
                format('#<%s total: %d>', self.class, @total)
            else
                format('#<%s total: %d, %s>', self.class, @total, @amount.map do |k, v|
                    "#{Array === k ? k.join('/') : k.to_s}: #{v}"
                end.join(', '))
            end
        end
    end

    X = Mana.new(infinite: 'X')
    Y = Mana.new(infinite: 'Y')
    Z = Mana.new(infinite: 'Z')
end

class Integer
    YAMTG::Mana::Colors.each do |color|
        define_method(color) do
            YAMTG::Mana.new(color => self)
        end
    end
end
