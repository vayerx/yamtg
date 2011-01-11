module YAMTG
    class Stack < Array
        def initialize(cards=[])
            super().replace(cards)
        end

        # Shuffle this stack
        def shuffle!
            l   = length
            for i in 0..(l-2)
                r = rand(l-i)+i
                self[r], self[i] = self[i], self[r]
            end
            self
        end

        # Get a random element of this stack
        # With an argument it gets you n elements without no index used more than once
        def random(n=nil)
            unless n then
                at(rand(length))
            else
                raise ArgumentError unless Integer === n and n.between?(0,length)
                ary = dup
                l   = length
                n.times { |i|
                    r = rand(l-i)+i
                    ary[r], ary[i] = ary[i], ary[r]
                }
                ary.first(n)
            end
        end
    end
end

