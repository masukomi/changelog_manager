require "readline"

module CliTool
	def ask_until_acceptable(message,
							valid_responses : Array(String)) : String
		input = Readline.readline(message).to_s
		if valid_responses.includes? input
			return input
		end
		return ask_until_acceptable(message, valid_responses)
	end

	
	def ask_yes_no(message) : Bool
		response = ask_until_acceptable((message + " [y/n]: "),
						 	 ["Y", "y", "N", "n"])
		if ["Y", "y"].includes? response
			return true
		end
		return false
	end

	def ask_for_non_optional_input(message : String) : String
		input = Readline.readline(message).to_s
		if input.match(/^\s*$/)
			puts "Please try again. That wasn't optional."
			return ask_for_non_optional_input(message)
		end
		return input
	end
	
	def get_change_type() : String
		int_change_type = ask_until_acceptable(
"What kind of Change?
1 - Fixed
2 - Changed
3 - Added\n",
							["1", "2", "3"]).to_i
		return ChangelogEntry::CHANGE_TYPES[int_change_type]
	end

end
