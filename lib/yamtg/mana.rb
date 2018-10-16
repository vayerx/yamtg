#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2011, Vasiliy Yeremeyev <vayerx@gmail.com>,                   #
#    (C) 2007, Stefan Rusterholz (rubyoh).                                  #
#                                                                           #
#    This program is free software; you can redistribute it and/or modify   #
#    it under the terms of the GNU General Public License as published by   #
#    the Free Software Foundation; either version 2 of the License, or      #
#    (at your option) any later version.                                    #
#                                                                           #
#    This program is distributed in the hope that it will be useful,        #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of         #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the           #
#    GNU General Public License for more details.                           #
#                                                                           #
#    You should have received a copy of the GNU General Public License      #
#    along with this program. If not, see <http://www.gnu.org/licenses/>    #
#    or write to the Free Software Foundation, Inc.,                        #
#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.              #
#############################################################################

require 'set'

module YAMTG

    class Mana
        Colors = %i{red green blue black white colorless}
        Chars  = { :red => "R", :green => "G", :blue => "B", :black => "K", :white => "W" }

        class << self
            def self.sort(colors)
                colors.sort_by { |color| Colors.index(color) }
            end
        end

        attr_reader :amount     # color pairs
        attr_reader :total      # total amount
        attr_reader :colors     # colors set (TODO excessive value)

        def initialize(mana={})
            @amount = Hash[*mana.map { |k, v| Array === k ? [Mana.sort(k), v] : [k, v] }.flatten]
            @amount.reject! { |k, v| k != :infinite && v.zero? }
            @amount.freeze
            @total  = @amount.values.inject(0) { |a, b| String === b ? a : a + b }
            @colors = @amount.keys.inject(Set.new) { |res, color| res << color if color != :colorless; res }
            @colors = [:colorless] if @colors.empty?
        end

        def [](key)
            @amount[Array === key ? Mana.sort(key) : key] || 0
        end

        def +(other)
            Mana.new(@amount.merge(other.amount) { |_key, a, b| a + b })
        end

        def -(other)
            raise RuntimeError, "Don't know how to substract #{other.class} from Mana" unless other.is_a? Mana
            raise RuntimeError, "Colorless mana detected!" if @amount.include? :colorless
            new = @amount.dup
            # exact matching
            other.amount.each do |color, amount|
                if color != :colorless
                    value = new[color]
                    raise RuntimeError, "Not enough #{color} mana: #{value} < #{amount}" if not value or value < amount
                    value > amount ? new[color] -= amount : new.delete( color )
                end
            end

            # handle colorless
            colorless = other.amount[:colorless]
            if colorless
                new.delete_if do |color, amount|
                    colorless -= (value = [colorless, amount].min)
                    (new[color] -= value) == 0
                end
                raise RuntimeError, "Oops, not enough mana to substract colorless" if colorless != 0
            end
            Mana.new(new)
        end

        def <(other)
            (!(self - other).zero?) rescue true   # TODO optimize
        end

        def >(other)
            other < self
        end

        def ==(other)
            return false if other.amount != @amount or other.total != @total
            other.amount.each { |color, amount| return false if @amount[color] == nil or @amount[color] != amount }
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
            k = @amount.keys - [:colorless, :infinite]
            if k.empty?
                :artifact
            else
                k.grep(Array).empty? && k.length == 1 ? k.first : :multicolor
            end
        end

        # can't print negative mana
        def to_s(x=false)
            a         = @amount.reject { |_k, v| !(String === v) && v < 1 }
            colorless = a[:colorless] ? ["(#{a.delete(:colorless)})"] : []
            infinite  = a[:infinite] ? ["(#{a.delete(:infinite).split(//).sort.join(')(')})"] : []
            if x
                monocolor  = Mana::Colors.map { |color| "#{a.delete(color)}x(#{Mana::Chars[color]})" if a[color] }.compact
                multicolor = a.map { |k,v| "#{v}x(#{k.map { |color| Mana::Chars[color] }.join('/')})" }
                (multicolor + monocolor + colorless + infinite).join(", ")
            else
                monocolor  = Mana::Colors.map { |color| "(#{Mana::Chars[color]})"*a.delete(color) if a[color] }.compact
                multicolor = a.map { |k,v| "(#{k.map { |color| Mana::Chars[color] }.join('/')})"*v }
                (multicolor + monocolor + colorless + infinite).join("")
            end
        end

        def inspect
            if @amount.empty?
                "#<%s total: %d>" %  [self.class, @total]
            else
                "#<%s total: %d, %s>" %  [self.class, @total, @amount.map { |k,v|
                    "#{Array === k ? k.join('/') : k.to_s}: #{v}"
                }.join(', ')]
            end
        end
    end

    X = Mana.new(:infinite => "X")
    Y = Mana.new(:infinite => "Y")
    Z = Mana.new(:infinite => "Z")

end

class Integer
    YAMTG::Mana::Colors.each { |color|
        define_method( color ) {
            YAMTG::Mana.new( color => self )
        }
    }
end
