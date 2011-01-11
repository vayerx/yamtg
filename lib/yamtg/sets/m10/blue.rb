#############################################################################
#    Yet Another 'Magic: The Gathering' Game Simulator                      #
#    (C) 2009-2010, Vasiliy Yeremeyev <vayerx@gmail.com>                    #
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

creature "Air Elemental" do
    cost        2.blue, 3.colorless
    type        "Elemental"
    power       4
    toughness   4
    flying
end

creature "Alluring Siren" do
    cost        1.blue, 1.colorless
    type        "Siren"
    power       1
    toughness   1

    description "{T}: Target creature an opponent controls attacks you this turn if able."

    legend <<-LEGEND_END.gsub(/\s+/, " ").strip
        "The ground polluted floats with human gore,\nAnd human carnage taints the dreadful shore\n
         Fly swift the dangerous coast: let every ear\nBe stopp'd against the song! 'tis death to hear!"\n
         -Homer, The Odyssey, trans. Pope
    LEGEND_END
end

creature "Clone" do
    cost        1.blue, 3.colorless
    type        "Shapeshifter"
    power       0
    toughness   0

    legend      "The shapeshifter mimics with a twin's esteem and a mirror's cruelty."
end

creature "Djinn of Wishes" do
    cost        2.blue, 3.colorless
    type        "Elemental"
    power       4
    toughness   4
    flying
    description <<-DESC_END.gsub(/\s+/, " ").strip
        {M}{M}{B}{B}: ...Reveal the top card of your library.
        You may play this card without paying its mana cost...
    DESC_END
end

aura "Convincing Mirage" do
    cost        1.blue, 1.colorless
end
