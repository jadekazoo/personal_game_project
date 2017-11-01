class Player
	@name
	@health

	def initialize()
		@health = 10
	end

	attr_accessor :name
	attr_reader :health
end

class Item
	@description = ""
	@name = ""

	def initialize(name, desc)
		@name = name
		@description = desc
	end

	def examine()
		puts @description
	end

	attr_reader :name

end

class Equipment < Item
	@equipped = false
	@spec_parameters = false

	def initialize(name, desc, spec_parameters)
		@name = name
		@description = desc
		@spec_parameters = spec_parameters
	end

	def equip()
		@equipped = true
	end

	def unequip()
		@equipped = false
	end
end

class Weapon < Equipment

end

class Room
	@name = ""
	@description
	@items = []
	# @north = false
	# @south = false
	# @west = false
	# @east = false
	@dark = false
	### Linked rooms is an array of room indexes that references the @rooms array in primary_game.rb
	@linked_rooms = [] # (north, south, west, east)||| north - 0, south - 1, west - 2, east - 3
	@locked = false
	# @npcs = nil
	# @interactions = nil


	# def initialize(name, desc, items, north, south, west, east, dark)#, npc_contents, interactions)
	def initialize(name, desc, items, exits, dark)#, npc_contents, interactions)
		@name = name
		@description = desc
		@items = items
		@linked_rooms = exits
		@dark = dark
		# @npcs = npc_contents
		# @interactions = interactions
	end

	def describe_to_player()
		if @dark == false
			puts @name
			puts @description
			counter = 1
			@items.each do |item|
				puts "There is one #{item.name}."
				counter += 1
			end
			@linked_rooms.each_with_index do |room, index|
				# (north, south, west, east)||| north - 0, south - 1, west - 2, east - 3
				case index
					when 0
						if room != false
							puts "There seems to be a northern exit"
						end
					when 1
						if room != false
							puts "There seems to be a southern exit"
						end
					when 2
						if room != false
							puts "There seems to be a western exit"
						end
					when 3
						if room != false
							puts "There seems to be an eastern exit"
						end
				end
			end
		else
			puts "It's too dark to make anything out in this room. You'll need to turn on the lights or use a light source."
		end
	end

	def num_items()
		return @items.length
	end

	# def item_examine(index)
	# 	@items[index].examine
	# end

	# def exits()

	# end
	attr_reader :linked_rooms
	attr_reader :items
end

class Interactable
	@name = ""
	@effect = ""

	def interact()
		puts ""
	end
end

class Container < Interactable
	@items = []


end

class Npc < Interactable

end