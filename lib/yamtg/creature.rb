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
    class Creature < Card
        class << self
            def inherited(by)
                by.offense 0
                by.defense 0
                super
            end

            def attack(value)
                @params[:attack] = value
            end

            def defense(value)
                @params[:defense] = value
            end
        end

        attr_reader :unmodified_offense
        attr_reader :unmodified_defense

        def initialize(params)
            @unmodified_offense = params.delete(:offense) || 0
            @unmodified_defense = params.delete(:defense) || 0
            super(params)
        end

        def can_attack?
            !tapped?
        end

        def can_defend?
            !tapped?
        end
    end
end
