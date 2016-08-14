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
		question_string = get_change_type_questions_string()
		answers = get_change_type_answers_list
		int_change_type = ask_until_acceptable(
			question_string,
			answers
		).to_i
		# quit if reqested
		if int_change_type == answers.last.to_i
			exit 0
		end
		# 
		return ChangelogEntry::CHANGE_TYPES_HASH[int_change_type]
	end

	def get_change_type_answers_list() : Array(String)
		cth = ChangelogEntry::CHANGE_TYPES_HASH
		sorted_keys = cth.keys.sort[0..(cth.keys.size - 1)]
		# - 2 because the last key is for internal use only
		# but + 1 because we want an exta one for the quit option
		# so - 1
		answers = sorted_keys.map{|x| x.to_s}
		answers.push((cth.keys.size + 1).to_s)
		return answers
	end
	def get_change_type_questions_string() : String
		question_string = "What kind of Change?"
		cth = ChangelogEntry::CHANGE_TYPES_HASH
		cth.keys.sort.each do |number|
			question_string += "\n#{number} - #{cth[number]}"
		end

		# allow users to quit
		quit_number = cth.keys.size + 1
		question_string += "\n#{quit_number} - Quit. No entry please."
		question_string += "\n#{cth.keys.sort.push(quit_number)}: "
		return question_string
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

	def get_stdin_from_tty()
		if ! STDIN.tty?
			STDIN.reopen(File.open("/dev/tty", "a+"))
		end
	end
end
