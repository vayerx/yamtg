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

require 'yamtg/set'

module YAMTG
    class Stack < Array
        def initialize( cards = [] )
            super().replace(cards)
        end

        # Get a random element of this stack
        # With an argument it gets you n elements without no index used more than once
        def random( n = nil )
            if n
                raise ArgumentError unless Integer === n and n.between?(0, length)
                arr = dup
                l = length
                n.times { |i|
                    r = rand(l - i) + i
                    arr[r], arr[i] = arr[i], arr[r]
                }
                arr.first(n)
            else
                at(rand(length))
            end
        end
    end
end
