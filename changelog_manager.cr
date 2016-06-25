
require "readline"
require "json"

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

class ChangelogEntry
	def initialize(description : String,
				   ticket      : String?,
				   url         : String?,
				   tags        : Array(String))
		@description = description
		@ticket      = ticket
		@url         = url
		@tags        = tags
	end
	
	# the following lets us ingest and expel json
	JSON.mapping({
		ticket: {type: String, nillable: true},
		url: {type: String, nillable: true},
		description: String,
		tags: Array(String)
	})
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

ticket      = Readline.readline("Ticket ID?: ")
url         = Readline.readline("Ticket URL?: ")
description = Readline.readline("Describe your change: ").to_s
# TODO support tags

changelog_entry = ChangelogEntry.new(description,
									ticket,
									url,
									[] of String)
puts changelog_entry.to_json
