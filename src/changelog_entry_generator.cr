require "./cli_tool"
class ChangelogEntryGenerator
	include CliTool


	def run()
		#OPTIONAL test if needs changelog

		called_from = File.expand_path(".").to_s

		cd = get_changelog_db(called_from)

		change_type = get_change_type()

		ticket      = Readline.readline("Ticket ID? (optional): ")
		url         = Readline.readline("Ticket URL? (optional): ")
		description = ask_for_non_optional_input("Describe your change: ")
		# TODO support tags

		changelog_entry = ChangelogEntry.new(change_type, 
											description,
											ticket,
											url,
											[] of String)
		# puts changelog_entry.to_json
		new_entry_location = changelog_entry.export(cd)
		success = GitIntegration.add_file(new_entry_location, changelog_entry)
		if success 
			puts "Added #{new_entry_location} to git"
		else
			#can't happen
			puts "Problems were encountered"
			exit 2
		end
		exit 0
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


	def get_changelog_db(called_from) : ChangelogDatabase
		cd = ChangelogDatabase.new(called_from)
		if cd.dot_changelog_entries_path().nil?
			prep_entries_directory(called_from, cd)
		end
		return cd
	end

	# def needs_changelog?() : Bool
	# 	ask_yes_no("Need Changelog Entry?")
	# 	if ! need_changelog 
	# 		puts "OK"
	# 		exit 0
	# 	end
	# end

end
