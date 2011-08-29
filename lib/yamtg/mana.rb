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

module YAMTG
    class Mana
        @colors = [:red, :green, :blue, :black, :white, :colorless].freeze
        @chars  = {:red => "R", :green=>"G", :blue=>"B", :black=>"K", :white=>"W"}.freeze
        class << self
            attr_reader :colors
            attr_reader :chars
            def self.sort(colors)
                colors.sort_by { |color| @colors.index(color) }
            end
        end

        attr_reader :amount
        attr_reader :total

        def initialize(mana={})
            @amount = Hash[*mana.map { |k,v| Array === k ? [Mana.sort(k), v] : [k, v]}.flatten]
            @amount.reject! { |k,v| k != :infinite && v.zero? }
            @amount.freeze
            @total  = @amount.values.inject(0) { |a,b| String === b ? a : a+b }
        end

        def [](key)
            @amount[Array === key ? Mana.sort(key) : key] || 0
        end

        def +(other)
            Mana.new(@amount.merge(other.amount) { |key, a,b| a+b })
        end

        # FIXME
        # implement colorless, multicolored and infinite
        def -(other)
            new = @amount.dup
            sub = other.amount.dup
            Mana.colors.each { |key|
                val      = (new[key]||0) - (sub.delete(key)||0)
                new[key] = val
                new.delete(key) if val.zero?
            }
            Mana.new(new)
        end

        # returns the colors that are negative if there are any
        def negative?
            found = @amount.reject { |k,v| !(String === v) && v >= 0 }
            found.empty? ? false : found.keys
        end

        def zero?
            @amount.empty?
        end

        def infer_color
            k = @amount.keys - [:colorless, :infinite]
            if k.empty? then
                :artifact
            else
                k.grep(Array).empty? && k.length == 1 ? k.first : :multicolor
            end
        end

        # can't print negative mana
        def to_s(x=false)
            a         = @amount.reject { |k,v| !(String === v) && v < 1 }
            colorless = a[:colorless] ? ["(#{a.delete(:colorless)})"] : []
            infinite  = a[:infinite] ? ["(#{a.delete(:infinite).split(//).sort.join(')(')})"] : []
            if x then
                monocolor  = Mana.colors.map { |color| "#{a.delete(color)}x(#{Mana.chars[color]})" if a[color] }.compact
                multicolor = a.map { |k,v| "#{v}x(#{k.map { |color| Mana.chars[color] }.join('/')})" }
                (multicolor + monocolor + colorless + infinite).join(", ")
            else
                monocolor  = Mana.colors.map { |color| "(#{Mana.chars[color]})"*a.delete(color) if a[color] }.compact
                multicolor = a.map { |k,v| "(#{k.map { |color| Mana.chars[color] }.join('/')})"*v }
                (multicolor + monocolor + colorless + infinite).join("")
            end
        end

        def inspect
            if @amount.empty? then
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

class Fixnum
    %w[red green blue black white colorless].each { |color|
        define_method( color ) {
            YAMTG::Mana.new( color => self )
        }
    }
end
