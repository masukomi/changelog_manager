require "tempfile"
require "./git_integration"
require "./changelog_entry"
require "./changelog_entry_generator"
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

	def entry_exists?(treeish : String) : Bool
		file_path = ".changelog_entries/#{treeish}.json"
		return File.exists? file_path
	end

	def display_findings(log : String, diff : String)
		puts log
		puts "#{"-" * 80}"
		puts diff.sub(/^[*-]\s+/, "")
		puts "#{"-" * 80}\nGIVEN THAT..."
	end

	def generate_new_entry(cd : ChangelogDatabase) : ChangelogEntry
		ceg = ChangelogEntryGenerator.new()
		config = cd.get_config()
		ce = ceg.get_changelog_entry_from_input(@changelog_database, config)
		return ce
	end

	def extract_changelog_entries_from_commits(commits : Array(String))
		commits.unshift(GitIntegration.get_first_commit())
		last_commit = nil as String?
		commits.each do |commit|
			if ! last_commit.nil?
				# skip it if we did it in a past run
				if entry_exists? commit
					last_commit = commit
					next
				end
				
				diff = get_diff(last_commit.to_s, commit)
				ticket = get_ticket_from_diff(diff)
				url = ticket == "" ? "" : get_url_from_diff(ticket, diff)
				log = get_log_for_commit(commit)


				display_findings(log, diff)
				
				if (ask_yes_no("Do you want to make an entry for this?"))
					ce = generate_new_entry(@changelog_database)
				end
			end
			last_commit = commit
		end
		puts "\n\n ALL DONE! Commit the changes!"
	end



	def get_diff(treeish_a : String, treeish_b : String) : String
		command = "git diff --no-color #{treeish_a} #{treeish_b} CHANGELOG.md | grep -e \"^+[*-]\" | sed -e \"s/^+ *//\""
		diff = GitIntegration.execute_or_error(command,
			"Unable to retrieve diff for #{treeish_a} #{treeish_b}")
	end

	# returns list of commits from oldest to newest
	def get_changelog_commits() : Array(String)
		commits = GitIntegration.execute_or_error(
			"git log --format=%H CHANGELOG.md",
			"Unable to retrieve commits to CHANGELOG.md"
		).chomp
		return commits.split("\n")
	end

	def get_log_for_commit(commit : String) : String
		return GitIntegration.execute_or_error(
					"git log --no-color --stat -n1 #{commit}",
					"Unable to get log for treeish: #{commit}")
	end

	def get_ticket_from_diff(diff : String) : String
		match = diff.match(/^[-*]\s+\[(.*?)\]/)
		if match
			return match[1]
		end
		return ""
	end
	def get_url_from_diff(ticket : String, diff : String) : String
		match = diff.match(/\[#{ticket}\](?:: |\()(http.*?)(?:\)|\s+$)/)
		if match
			return match[1]
		end
		return ""
	end
end

cm = ChangelogMigrator.new()
cm.run()
