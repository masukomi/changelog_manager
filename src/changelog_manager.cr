require "readline"
require "json"
require "./changelog_manager/*"
require "./changelog_entry"
require "./changelog_database"





change_types = {
	1 => "Fixed",
	2 => "Changed",
	3 => "Added"
}

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



################################################################################
need_changelog = ask_yes_no("Need Changelog Entry?")
if ! need_changelog 
	puts "OK"
	exit 0
end

called_from = File.expand_path(".").to_s

cd = ChangelogDatabase.new(called_from)
if cd.dot_changelog_entries_path().nil?
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



change_type = change_types[
					ask_until_acceptable(
"What kind of Change?
1 - Fixed
2 - Changed
3 - Added\n",
						["1", "2", "3"]).to_i]

ticket      = Readline.readline("Ticket ID? (optional): ")
url         = Readline.readline("Ticket URL? (optional): ")
description = ask_for_non_optional_input("Describe your change: ")
# TODO support tags

changelog_entry = ChangelogEntry.new(description,
									ticket,
									url,
									[] of String)
puts changelog_entry.to_json




# module ChangelogManager
#   # TODO Put your code here
# end
