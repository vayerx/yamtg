#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2011, Vasiliy Yeremeyev <vayerx@gmail.com>                    #
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

creature 'Tideforce Elemental' do
    cost        1.blue, 2.colorless
    type        :Elemental
    power       2
    toughness   1

    ability 1.colorless, :tap do |arena, card|
        # TODO
    end

    description <<-DECRIPTION_END.gsub(/\s+/, ' ').strip
        {U}, {T}: You may tap or untap another target creature.\n
        Landfall - Whenever a land enters the battlefield under your control,
        you may untap Tideforce Elemental.
    DECRIPTION_END

    legend 'Flavor: Ebb and flow, high tide and low, quick as sand and just as slow.'
end
