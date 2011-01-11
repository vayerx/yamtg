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

creature "Black Knight" do
    cost        2.black
    type        "Human Knight"
    power       2
    toughness   2
    first_strike

    description "Protection from white"
end

creature "Child of Night" do
    cost        1.black, 1.colorless
    type        "Vampire"
    power       2
    toughness   1
    lifelink

    legend  "A vampire enacts vengeance on the entire world, claiming her debt two tiny pinpricks at a time."
end

creature "Dread Warlock" do
    cost        2.black, 1.colorless
    type        "Human Wizard"
    power       2
    toughness   2

    description "Dread Warlock can't be blocked except by black creatures"
end

creature "Drudge Skeletons" do
    cost        1.black, 1.colorless
    type        "Skeleton"
    power       1
    toughness   1

    description "{K}: Regenerate Drudge Skeletons"
end

source "Demon's Horn" do
    cost        2.colorless
    artifact
end

source "Duress" do
    cost        1.black
    description "Target oppenent releals his or her hand..."
end
