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

require 'yamtg/permanent'

module YAMTG
    class Creature < Tapable
        class << self
            %w[power toughness].each { |name|
                define_method( name ) { |*val|
                    return class_variable_get( '@@' + name ) if val.empty?
                    class_variable_set( '@@' + name, val.first )
                }
            }
            def init
                super
                class_variable_set :@@power, 0
                class_variable_set :@@toughness, 0
            end
        end

        def initialize
            super
            @power     = unmodified_power
            @toughness = unmodified_toughness
        end

        attr_accessor  :power, :toughness
        %w[power toughness].each { |name|
            define_method( 'unmodified_' + name ) { self.class.send( :class_variable_get, '@@' + name ) }
        }

        def can_attack?
            !tapped?
        end

        def can_block?(card = nil)
            if card
                # TODO {island,...}walk should be handled somewhere (battlefield required)
                return false if card.has? :unblockable
                return false if card.has? :flying and !(has? :flying or has? :reach)
                return false if card.has? :fear and not colors.include? :black
            end
            !tapped?
        end

        def inspect
            ab = ability_names
            "[%s]: %s %d/%d, %s" % [ name, self.class.superclass.to_s.sub( /YAMTG::/, ''), power, toughness, color ] +
                (ab.empty? ? "" : ' {' + ab.join(',') + '}') +
                ' ' + (tapped? ? "tapped" : "untapped")
        end
    end


    class Defender < Creature
        def can_attack?
            false
        end
    end
end
