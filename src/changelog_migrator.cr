require "tempfile"
require "./git_integration"
require "./changelog_entry"
require "./cli_tool"

class ChangelogMigrator
	include CliTool
	@changelog_database : ChangelogDatabase
	def initialize
		@changelog_database = get_changelog_db(get_called_from())
	end
	def run()
		commits = get_changelog_commits()
		extract_changelog_entries_from_commits(commits)
	end

	def extract_changelog_entries_from_commits(commits : Array(String))
		commits.unshift(GitIntegration.get_first_commit())
		last_commit = nil#.as(String?)
		commits.each do |commit|
			if ! last_commit.nil?
				# skip it if we did it in a past run
				file_path = ".changelog_entries/#{commit}.json"
				if File.exists? file_path
					last_commit = commit
					next
				end
				
				diff = get_diff(last_commit.to_s, commit)
				ticket = get_ticket_from_diff(diff)
				url = ticket == "" ? "" : get_url_from_diff(ticket, diff)
				log = get_log_for_commit(commit)



				puts log
				puts "#{"-" * 80}"
				puts diff
				puts "#{"-" * 80}\nGIVEN THAT..."

				change_type = get_change_type()

				ce = ChangelogEntry.new(change_type,"",ticket, url, [] of String)

				ce = process_commit_data(ce, log, diff, commit, false)
				exit 0
			end
			last_commit = commit
		end
		puts "\n\n ALL DONE! Commit the changes!"
	end

	def process_commit_data(ce     : ChangelogEntry,
							log    : String,
							diff   : String,
							commit : String,
							previous_failure = false) : ChangelogEntry
		begin 
			text ="#{ce.to_json}#{get_helper_text(log, diff, previous_failure)}"

			json = get_edited_text(text)
			ce = ChangelogEntry.from_json(json)
			export_and_add(ce, commit)
		rescue
			process_commit_data(ce, log, diff, commit, true)
		end
		return ce
	end

	def get_helper_text(log : String, diff : String, previous_failure : Bool) : String
		text = "
===================================
Delete this line ^^ and everything below it

"
		if previous_failure
			text += "SORRY! The result must be valid json.\n"
			text += "Please try again.\n"
		end

		text += "\n\n" + diff + "\n\n" + log
		return text
	end

	def export_and_add(ce : ChangelogEntry, commit : String)
		new_entry_location = ce.export(@changelog_database, commit)
		new_entry_location = GitIntegration.add_file(new_entry_location)
		puts "created #{new_entry_location}"
	end

	def get_diff(treeish_a : String, treeish_b : String) : String
		command = "git diff --no-color #{treeish_a} #{treeish_b} CHANGELOG.md | egrep -v 'CHANGELOG.md|index|@@'"
		puts command
		diff = GitIntegration.execute_or_error(command,
			"Unable to retrieve diff for #{treeish_a} #{treeish_b}")
	end

	# returns list of commits from oldest to newest
	def get_changelog_commits() : Array(String)
		commits = GitIntegration.execute_or_error(
			"git log --reverse --format=%H CHANGELOG.md",
			"Unable to retrieve commits to CHANGELOG.md"
		).chomp
		return commits.split("\n")
	end

	def get_edited_text(text : String) : String
		tempfile = Tempfile.open("changelog_migrator"){ |file|
			file.print(text)
		}
		system("vi #{tempfile.path}")
		contents = File.read(tempfile.path)
		File.delete(tempfile.path)
		return contents
	end

	def get_log_for_commit(commit : String) : String
		return GitIntegration.execute_or_error(
					"git log --no-color --stat -n1 #{commit}",
					"Unable to get log for treeish: #{commit}")
	end

	def get_ticket_from_diff(diff : String) : String
		match = diff.match(/[+][-*] \[(.*?)\]/)
		if match
			return match[1]
		end
		return ""
	end
	def get_url_from_diff(ticket : String, diff : String) : String
		puts "GET URL FROM DIFF #{ticket}"
		match = diff.match(/\[#{ticket}\](?:: |\()(http.*?)(?:\)|\s+$)/)
		if match
			return match[1]
		end
		return ""
	end
end

cm = ChangelogMigrator.new()
cm.run()
