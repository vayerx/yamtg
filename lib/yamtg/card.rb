#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2010, Vasiliy Yeremeyev <vayerx@gmail.com>,                   #
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
    class Card
        class << self
            def inherited(by)
                by.init
            end

            def init
                @params = {
                    :cost        => Mana.new,
                    :types       => [],
                    :name        => "",
                    :description => "",
                    :legend      => "",
                }
            end

            def param(name)
                define_method(name) { |*args|
                    if args.empty? then
                        @params[name]
                    else
                        @params[name] = args.first
                    end
                }
            end

            def cost(*mana)
                @params[:cost] = mana.inject(Mana.new) { |a,b| a+b }
            end

            def name(val)
                @name = val
            end

            def description(val)
                @params[:description] = val
            end
        end

        # Name of this card
        attr_reader :name

        # Mana this card costs to play
        attr_reader :cost

        # English description of abilities of this card
        attr_reader :description

        # An entertaining string with a piece of story for the player
        attr_reader :legend

        # how many of any token is on this card
        attr_reader :tokens

        # :library, :hand, :field, :graveyard, :out_of_game, :transit_<from>_<to>
        attr_reader :zone

        def initialize(name, params)
            @name        = name.freeze
            @cost        = params.delete(:cost)
            @colors      = params.delete(:colors) || @cost.infer_color
            @class       = params.delete(:class)
            @types       = params.delete(:types) || []
            @description = params.delete(:description) || ""
            @legend      = params.delete(:legend) || ""

            @tapped       = false
            @zone         = nil
            @attachements = []    # cards (enchantments, equipments) attached to this card
            @tokens       = Hash.new(0)
        end

        def class?(klass)
            @class == klass
        end

        def type?(type)
            @types.include?(type)
        end

        def color?(color)
            @colors.include?(color)
        end

        def tapped?
            @tapped
        end

        def attach(card)
            @attachements << card
        end

        def detach(card)
            @attachements.delete(card)
        end
    end
end
