require_relative "classes"

@player = Player.new
@inventory = []
@max_inv_size = 10
@rooms = []
@enter_room = false

def welcome_menu

	print "Hello, adventurer! Please, tell us your name: " 
	@player.name = gets.chomp.capitalize
	puts "Hello, #{@player.name}! Let's get started."
	establish_rooms()
	sleep 1
	puts ""
	system 'clear'
	system 'cls'
	interface(0)

end


### Primary interface for displaying room information and interactability, takes the argument of current_room which is an integer index for the @rooms array
def interface(current_room)

	if @enter_room == false
		@rooms[current_room].describe_to_player
		@enter_room = true
	end
	sleep 1
	puts ""
	puts "What would you like to do?"
	user_input = gets.chomp.downcase
	first_word = user_input
	second_word = ""
	chop_this = false
	if user_input.include?(" ")
		temp_array = []
		temp_array = user_input.split(" ")
		first_word = temp_array[0]
		first_done = false
		temp_array.each do |word|
			if first_done == false
				first_done = true
			else
				second_word = second_word + word + " "
				chop_this = true
			end
		end
		if chop_this == true
			second_word = second_word.chop
		end
	end

	item_quantity = @rooms[current_room].num_items

	case first_word
		when "help"
			#Help command to give the player the ability to know what to do
			puts "Available commands: "
			# puts "Examine [number] (ex: \"Examine 1\" will examine the object with value 1 in the room.)"
			puts "Examine [item, self, room] (will ask you what you want to examine)"
			puts "I (open inventory)"
			puts "Inventory (open inventory)"
			puts "Go [north, south, east, west] (goes north, south, east, or west"
			puts "North (goes north)"
			puts "South (goes south)"
			puts "West (goes west)"
			puts "East (goes east)"
			puts "N (goes north)"
			puts "S (goes south)"
			puts "W (goes west)"
			puts "E (goes east)"
			puts "Get [item] (picks up an item in the room)"
			puts "Drop [item] (drops an item from your inventory)"
			puts "Use [item] (uses an item in the room or from your inventory)"
			puts "Exit (exits program)"
			interface(current_room)
		when "examine"
			examine_method_room(current_room, second_word)
		when "i", "inventory"
			puts "You have #{@inventory.length} item(s) in your inventory:"
			@inventory.each do |item|
				puts "#{item.name}"
			end
			interface(current_room)
		when "get"
			pick_up(current_room, second_word)
		when "drop"
			drop(current_room, second_word)
		when "use"
			use(current_room)
		when "north", "south", "west", "east", "go", "n", "s", "w", "e"
			change_room(current_room, second_word, first_word)
		when "exit"
			sleep 1
			system 'clear'
			system 'cls'
			abort("Bye, #{@player.name}!")
		else
			puts "Sorry, I don't recognize \"#{user_input}\""
			interface(current_room)
	end

end

### Examine method for rooms & items in rooms. There will be another for the inventory
def examine_method_room(current_room, second_word)
	if second_word != ""
		caught = false
		@rooms[current_room].items.each do |item|
			if second_word == item.name.downcase
				item.examine
				caught = true
			end
		end

		if caught == false
			case second_word
			when "room"
				@rooms[current_room].describe_to_player
			when "me", "self", "player"
				puts "Your name is #{@player.name} and you have #{@player.health} hitpoints"
			else
				puts "Sorry, I don't recognize \"#{second_word}\" under \"examine\""
			end
		end
	else
		puts ""
		print "What would you like to examine? "
		user_input = gets.chomp.downcase
		examine_method_room(current_room, user_input)
	end
	interface(current_room)
end

### Method for picking up an item
def pick_up(current_room, second_word)
	check = inventory_check()
	if second_word != "" && check == true
		caught = false
		@rooms[current_room].items.each_with_index do |item, index|
			if second_word == item.name.downcase && caught == false
				@inventory.push(item)
				@rooms[current_room].items.delete_at(index)
				caught = true
				puts "You pick up #{item.name}"
			end
		end

		if caught == false
			puts "You can't do that!"
		end
	elsif second_word == "" && check == true
		puts ""
		print "What would you like to pick up? "
		user_input = gets.chomp.downcase
		pick_up(current_room, user_input)
	else
		puts "Inventory full"
	end
	interface(current_room)
end

### Method for dropping an item
def drop(current_room, second_word)
	if second_word != ""
		caught = false
		@inventory.each_with_index do |item, index|
			if second_word == item.name.downcase && caught == false
				@rooms[current_room].items.push(item)
				@inventory.delete_at(index)
				caught = true
				puts "You drop #{item.name}"
			end
		end

		if caught == false
			puts "That's not something you can drop."
		end
	else
		puts ""
		print "What would you like to drop? "
		user_input = gets.chomp.downcase
		drop(current_room, user_input)
	end
	interface(current_room)
end


### Checks if Player inventory is full
def inventory_check()
	if @inventory.length == @max_inv_size
		return false
	else
		return true
	end
end


### Changes the room
def change_room(current_room, second_word, first_word)
	if first_word == "go"
		first_word = first_word
	else
		second_word = first_word
	end

	if second_word != ""
		caught = false
		case second_word
			when "north", "n"
				if @rooms[current_room].linked_rooms[0] != false
					@enter_room = false
					interface(@rooms[current_room].linked_rooms[0])
				else
					puts "There isn't a northern exit!"
				end
			when "south", "s"
				if @rooms[current_room].linked_rooms[1] != false
					@enter_room = false
					interface(@rooms[current_room].linked_rooms[1])
				else
					puts "There isn't a southern exit!"
				end
			when "west", "w"
				if @rooms[current_room].linked_rooms[2] != false
					@enter_room = false
					interface(@rooms[current_room].linked_rooms[2])
				else
					puts "There isn't a western exit!"
				end
			when "east", "e"
				if @rooms[current_room].linked_rooms[3] != false
					@enter_room = false
					interface(@rooms[current_room].linked_rooms[3])
				else
					puts "There isn't an eastern exit!"
				end
			else
				puts "That's not a direction!"
		end
	else
		puts ""
		print "Where would you like to go?"
		user_input = gets.chomp.downcase
		change_room(current_room, user_input, user_input)
	end
	interface(current_room)
end


### Method for using an item
def use(current_room)
	interface(current_room)
end


### Hard-coded rooms method that fills the @rooms array with each room I build. There has to be a better way, but for right now I just want this program to function
def establish_rooms()
	# def initialize(name, desc, items, north, south, west, east, dark) #, npc_contents, interactions)
	# (north, south, west, east)||| north - 0, south - 1, west - 2, east - 3

	# Room "Living Room", Index = 0
	necklace_one = Equipment.new("Dull Necklace", "A vaguely pretty necklace", false)
	notebook_one = Item.new("Triangle Notebook", "Huh. Why is it triangular?")
	temp_item_array = []
	temp_exits_array = [1, 2, false, false]
	temp_item_array.push(necklace_one, notebook_one) #necklace = index 0 & #notebook = index 1
	room_one = Room.new("Living Room", "This is the living room.", temp_item_array, temp_exits_array, false)
	@rooms.push(room_one)

	# Room "Kitchen", Index = 1
	cell_phone = Item.new("iPhone 3G", "An iPhone 3G. What is this, 2008?")
	oven_mitt = Equipment.new("Oven Mitt", "It's an oven mitt, and it's bright neon green.", false)
	temp_item_array = []
	temp_exits_array = [false, 0, false, false]
	temp_item_array.push(cell_phone, oven_mitt)
	room_two = Room.new("The Kitchen", "This kitchen is very clean, it looks like it's from an advertisement.", temp_item_array, temp_exits_array, false)#true)
	@rooms.push(room_two)

	# Room "Bathroom", Index = 
	

	# Room "Bedroom", Index = 2
	key_ring = Item.new("#{@player.name}'s Keys", "Your keys!")
	baseball_cap = Equipment.new("Baseball Cap", "A baseball cap, it's dark grey.", false)
	temp_item_array = []
	temp_exits_array = [0, false, false, false]
	temp_item_array.push(key_ring, baseball_cap)
	room_three = Room.new("Bedroom", "This is an absolute mess.", temp_item_array, temp_exits_array, false)
	@rooms.push(room_three)

	# Room "Apartment Complex", Index = 4


end


###########################################