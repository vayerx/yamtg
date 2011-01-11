source "Plains" do
	type        "Land"
	description "(Tap): Generate (W)"

	tap do |arena, card|
		card.owner.add_mana(1.white)
	end
end

# Rather cheap flying attacker
monster "Pegasus" do
	cost   2.white
	type   "Animal"
	
	flying
	first_strike
	
	offense 100
	defense 100
end

# Weak Blocker type, but at least it's tough and can be eaten
defender "Honeypot Plant" do
	cost    1.white, 1.colorless
	type    "Plant"
	
	description "(Tap): Sacrifice to gain 5 life"
	legend   "These plants were created by the great magicians to endure lasting sieges."
	
	tap do |arena, card|
		arena.destroy(card)
		card.owner.life += 100 
	end

	defense 200
end

monster "Lancer of the Sacred Rose" do
	cost 1.white
	type "Knight"
	
	first_strike
	
	offense 50
	defense 50
end

# Decent fighter.
monster "Knight of the Sacred Rose" do
	cost 2.white, 1.colorless
	type "Knight"

	legend "Honour is my life."

	first_strike

	offense: 250
	defense: 200
end


# Also a decent fighter but got a big horse as his mount, so has 
# a higher offense power while retaining first strike.
monster "Rider of the Sacred Rose" do
	cost 2.white 2.colorless
	type "Knight"

	first_strike

	offense: 250
	defense: 150
end

# Expensive big creature for late-game.
monster "Paladin of the Sacred Rose" do
	cost 3.white 3.colorless
	type "Paladin"
	
	first_strike

	description "(Tap)(W): Prevent any target from 100 damage"
	legend      "Honour your friends."

	tap 1.white do |arena, card|
		# prevent 100 damage dealt to any target, the damage is dealt to
		# paladin of the sacred rose
		# card.owner.pick_damageable_target.intercept(:receiving_damage) do |modifier, arena2, target, params|
		# 	params.effective_damage -= 100
		# 	card.damage(100)
		#   modifier.remove
		# end
	end

	offense: 300
	defense: 200
end
