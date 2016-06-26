require "./changelog_manager/*"


require "readline"
require "json"
require "changelog_entry"

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

def ask_for_non_optional_input(message : String) : String
	input = Readline.readline(message).to_s
	if input.match(/^\s*$/)
		puts "Please try again. That wasn't optional."
		return ask_for_non_optional_input(message)
	end
	return input
end



################################################################################
need_changelog = ask_until_acceptable("Need Changelog Entry? [y/n]: ",
									  ["y", "n"])
if need_changelog != "y"
	puts "Alas..."
	exit 0
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
