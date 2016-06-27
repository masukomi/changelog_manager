require "readline"
require "json"
require "option_parser"

require "./changelog_manager/*"
require "./changelog_entry"
require "./changelog_database"
require "./changelog_entry_generator"
require "./changelog_generator"
require "./git_integration"


# Exit statuses
# 1 - couldn't find / create .changelog_entries
# 2 - couldn't add a changelog entry to git

generate_entry = false
generate_log = false
log_version = nil as String?

OptionParser.parse! do |parser|
	parser.banner = "Usage: changelog_manager [arguments]"
	parser.on("-l", "--log", "Generate CHANGELOG.md for all entries") { generate_log = true }
	parser.on("-v VERSION", 
				"--to=VERSION", 
				"Generates CHANGELOG.md for specific version"
			 ) { |version| log_version = version }
end

if ! generate_log
	ceg = ChangelogEntryGenerator.new()
	ceg.run()
else
	cg = ChangelogGenerator.new()
	cg.generate(log_version)
end





# module ChangelogManager
#	 # TODO Put your code here
# end
