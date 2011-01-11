# blue typically does not have the best creatures, because normally
# the blue spells, and counterspells control the game.
# blue does however have some fliers and some other good creatures
# like creatures with "unblockable" sneak through enemy lines or
# draw-card abilities, and of course it has some key "avatar" cards 
# for late game just like the other colours too.

# Blue flier. Should be in spirit like the black bat, and the 
# white pegasus, but its a bit more expensive.
monster "Zephyr of the sky" do
	cost    1.blue, 2.colorless
	type    "Bird" # or Animals/Bird or just Bird?

	vigilance # attacking does not cause him to tap

	#ability :shield, 1.white, :tap do
	#  description "Prevent two damage to any target."
	#end

	offense  150 # 3
	defense   50 # 1
end



monster "Blue Knight of Deceit" do
	cost 2.blue
	type "Knight"

	first_strike

	#description "(B): Blue Knight of Deceit changes his colors to a color of your choice, this change is permanent."

	#ability 1.blue do
	#
	#end

	offense: 100 # 2
	defense: 100 # 2
end



monster "Tyrant of the Deep" do
	cost 3.blue 2.colourless
	type "Human"

	legend "The tyrants of the deep were skilled but expensive mercenaries that were 
	       able to destroy enemy units with great ease - if they had enough time to 
	       invoke their wicked magic." 

	tap 3.blue do
		description "Destroy target tapped permanent. Use this ability only during your turn."
	end

	offense: 100 # 2
	defense: 200 # 4
end


# Wizard that helps to untap permanents
monster "Emergency Wizard" do
	cost 2.blue
	type "Human"

	legend "The Emergency Wizards were useful to return battle units to home quickly." 

	tap 1.blue do
		description "Untap target permanent you control."
	end

	offense:   0 # 0
	defense: 100 # 2
end



# 
monster "Deep Sea Underground Oracle" do
	cost 4.blue 6.colorless
	type "Other" # Dunno... energy thing?

	description "When this card comes into play, draw 2 cards\n" \
	            "(Tap): Draw 2 cards"
	legend "The Oracle was a difficult place to reach, but once " \
	       "someone found it, it was a place for wisdom and knowledge." 

	event :comes_into_play do |arena, card|
		card.owner.takeup(2)
	end

	# tap it to draw 2 cards
	tap do |arena, card|
		card.owner.takeup(2)
	end

	offense:   0 # 0
	defense: 700 # 14
end
