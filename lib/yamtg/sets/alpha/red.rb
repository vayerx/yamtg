source "Mountain" do
	type        "Land"
	description "(Tap): Generate (R)"

	tap do |arena, card|
		card.owner.add_mana(1.red)
	end
end

monster "Dwarven Soldier" do
	cost    1.red
	type    "Dwarf"
	offense 50
	defense 100
end

monster "Mountain Ogre" do
	cost    1.red, 2.colorless
	type    "Ogre"
	offense 150
	defense 200
end

monster "Cave Troll" do
	cost    1.red, 2.colorless
	type    "Troll"
	offense 100
	defense 200
	description "(R): Cave Troll gains +200/-50 until end of turn"
	
	ability :anger, 1.red do
		@anger += 1
	end
	
	event :end_of_turn do |arena, card|
		card.anger = 0
	end

	attr_accessor :anger
	def initialize
		@anger = 0
	end
	def offense
		@offense+@anger*200
	end
	def defense
		@defense-@anger*50
	end
end

defender "Stonewall" do
	cost    1.red, 2.colorless
	type    "Wall"
	defense 250
	
	description "(R)(R): Stonewall gains +150/0  until end of turn"
	legend      "The screams were unbearable when the defenders poured boiling oil over the attackers."
	
	ability :anger, 2.red do
		@anger += 1
	end
	
	event :end_of_turn do |arena, card|
		card.anger = 0
	end

	attr_accessor :anger
	def initialize
		@anger = 0
	end
	def offense
		@offense+@anger*150
	end
end
