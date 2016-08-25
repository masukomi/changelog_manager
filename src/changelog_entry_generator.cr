require "./cli_tool"
class ChangelogEntryGenerator
	include CliTool

	def get_changelog_entry_from_input(cd : ChangelogDatabase, 
									   config : ChangelogConfig ) : ChangelogEntry
		change_type = get_change_type()

		ticket      = Readline.readline("Ticket ID? (optional): ")
		url         = nil as String?
		if ticket.to_s != "" && config.ticket_url_prefix
			url = config.ticket_url_prefix.to_s + ticket.to_s
		else
			url         = Readline.readline("Ticket URL? (optional): ")
		end
		description = ask_for_non_optional_input("Describe your change: ")
		description = description.gsub(/\\\\n/, "\\n")
		# enable descriptions with encoded newlines

		raw_tags = Readline.readline("Tags (Optional, comma separated): ")
		tags = raw_tags.to_s.split(/,\s*/).select{|x| !x.nil? && x != ""} 
		# I don't trust them to follow instructions

		changelog_entry = ChangelogEntry.new(change_type, 
										description,
										ticket.to_s == "" ? nil : ticket.to_s,
										url.to_s == "" ? nil : url.to_s,
										tags)
		return changelog_entry
	end
	def run()

		get_stdin_from_tty()
		# If we're being run as a git hook
		# we need to reopen STDIN from tty because git doesn't
		# want interative commit hooks.
		# Tough shit git. :P

		#OPTIONAL test if needs changelog

		cd = get_changelog_db(get_called_from())
		config = cd.get_config()


		changelog_entry = get_changelog_entry_from_input(cd, config)
		# puts changelog_entry.to_json
		new_entry_location = changelog_entry.export(cd)
		success = false
		if config.git_add
			success = GitIntegration.add_file(new_entry_location)
		end
		if success 
			puts "Added #{new_entry_location} to git"
		elsif ! config.git_add
			puts "Created #{new_entry_location}"
		elsif config.git_add
			#can't happen
			puts "Problems were encountered adding the new entry to git"
			exit 2
		end
		exit 0
	end





	# def needs_changelog?() : Bool
	# 	ask_yes_no("Need Changelog Entry?")
	# 	if ! need_changelog 
	# 		puts "OK"
	# 		exit 0
	# 	end
	# end

end
