require "readline"
require "./changelog_database"

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
3 - Added
[1,2,3]: ",
							["1", "2", "3"]).to_i
		return ChangelogEntry::CHANGE_TYPES[int_change_type]
	end

	def get_changelog_db(called_from : String) : ChangelogDatabase
		cd = ChangelogDatabase.new(called_from)
		if cd.dot_changelog_entries_path().nil?
			prep_entries_directory(called_from, cd)
		end
		return cd
	end

	def get_called_from() : String
		called_from = File.expand_path(".").to_s
	end
	
	def prep_entries_directory(called_from : String, cd : ChangelogDatabase)
		puts "I couldn't find a .changelog_entries directory here"
		puts "\t#{called_from}"
		puts "or in any directory above it."
		can_create = ask_yes_no( "Can I create it there?")
		if can_create
			cd.create_default_folder()
			puts "I've created it. Thanks.\n------------------"
		else
			puts "I can't continue without that. Sorry."
			exit 1
		end
	end
end
