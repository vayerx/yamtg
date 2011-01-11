source "Swamp" do
	type        "Land"
	description "(Tap): Generate (K)"

	tap do |arena, card|
		card.owner.add_mana(1.black)
	end
end

defender "Tarpit" do
	cost    1.black, 1.colorless
	type    "Trap"
	offense 0
	defense 200

	description "(K)(K): When blocking, destroy the blocked card, the card still deals the damage"
	legend      "It was his last mistake not to watch his step, and the more he tried to free himself, the deeper he sank into the undefinable black fluid."

	ability :drown, 2.black do |arena, card|
		raise InvalidTiming unless card.blocking?
		destroy = if card.blocking.length > 1 then
			card.owner.pick_card(card.blocking)
		else
			card.blocking.first
		end
		arena.destroy(card, :end_of_turn)
	end
end

monster "Dead Rat" do
	cost    1.black
	type    "Zombie"
	offense 50
	defense 50
	
	description "(K): Regenerate"
	
	ability :regenerate, 1.black do |arena, card|
		arena.regenerate(card)
	end
end

monster "Bat" do
	cost   1.black
	type   "Animal"
	flying
	
	offense 50
	defense 50
end

monster "Gargoyle" do
	cost   2.black
	type   "Creature"
	flying
	offense 100
	defense 100
	
	description "(K): Turn gargoyle into 0/200 non-flying artefact until end of turn."
	legend      "Stone at day, murdering beast at night."
	
	ability :morph, 1.black do |arena, card|
		card.morph(true)
	end
	event :end_of_turn do |arena, card|
		card.morph(false)
	end

	def morph(to_artefact)
		if to_artefact then
			@offense = 0
			@defense = 200
			@flags   = []
		else
			@offense = 100
			@defense = 100
			@flags   = [:flying]
		end
	end
end

monster "Cloud Phantom" do
	cost    2.black 1.colorless
	type    "Illusion"
	offense 150
	defense 250
end
