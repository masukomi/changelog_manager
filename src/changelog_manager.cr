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
with_tags = Set(String).new
log_version = nil as String?

OptionParser.parse! do |parser|
	parser.banner = "Usage: changelog_manager [arguments]"
	parser.on("-c", "--compile", "Generate CHANGELOG.md for all entries") { 
		generate_log = true }
	parser.on("-w TAGS", "--with-tags=TAGS", 
"Used with -c to produce output containing with no tags or one, 
or more of the specified tags. Takes a comma separated list (no spaces)."
			 ) { | tags_string | tags = tags_string.split(",").select{|x| x != ""}
								with_tags = Set.new(tags)}
	parser.on("-v VERSION", 
				"--to=VERSION", 
				"Generates CHANGELOG.md for specific version"
			 ) { |version| log_version = version }
	
	parser.on("-h", "--help", "Show this help") { 
		puts parser
		exit 0
	}
end

if ! generate_log
	ceg = ChangelogEntryGenerator.new()
	ceg.run()
else
	cg = ChangelogGenerator.new()
	cg.generate(log_version, with_tags)
end





# module ChangelogManager
#	 # TODO Put your code here
# end
