require_relative "classes"
require_relative "primary_game"

RSpec.configure do |config|
  config.failure_color = :yellow
end

RSpec.describe "split words" do

	it '#1 splits user_input and returns first_word as the first word' do
		puts "What would you like to do?"
		user_input = "Examine necklace".downcase
		puts "Examine necklace"
		first_word = user_input
		second_word = ""
		if user_input.include?(" ")
			temp_array = []
			temp_array = user_input.split(" ")
			first_word = temp_array[0]
			first_done = false
			temp_array.each do |word|
				if first_done == false
					first_done = true
				else
					second_word = second_word + word
				end
			end
		end
		expect(first_word).to eq("examine")
		#expect("Hello").to eq("Hello")
	end

	it '#2 splits user_input and returns words after first_word as second_word' do
		puts "What would you like to do?"
		user_input = "Examine necklace and boots".downcase
		puts "Examine necklace and boots"
		first_word = user_input
		second_word = ""
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
				end
			end
			second_word = second_word.chop
		end
		puts "#{second_word}"
		expect(second_word).to eq("necklace and boots")
	end

	it '#3 how am I not getting self under examine??' do
		user_input = "Examine self".downcase
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
		expect(second_word).to eq("self")
	end
	# note to anyone reading this: my problem here in #3 ended up being a syntax error in the examine method of primary_game.rb. it's been fixed

	it '#4 how do I do an && in a case statement, for Room.describe_to_player' do
		array1 = [1, false, false, false]
		test1 = "Did not work."
		array1.each_with_index do |value, index|
			case index
				when 0
					if value != false
						test1 = "Did work"
					end
				when 1
					if value != false
						test1 = "Did work"
					end
				when 2
					if value != false
						test1 = "Did work"
					end
				when 3
					if value != false
						test1 = "Did work"
					end
			end
		end
		expect(test1).to eq("Did work")
	end

end