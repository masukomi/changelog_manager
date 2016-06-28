require "tempfile"
require "./git_integration"
require "./changelog_entry"

class ChangelogMigrator

	def run()
		commits = get_changelog_commits()
		extract_changelog_entries_from_commits(commits)
	end

	def extract_changelog_entries_from_commits(commits : Array(String))
		
		commits.unshift(GitIntegration.get_first_commit())
		last_commit = nil as String?
		commits.each do |commit|
			if ! last_commit.nil?
				# skip it if we did it in a past run
				next if File.exists? ".changelog_entries/#{commit}.json"

				diff = get_diff(last_commit.to_s, commit)
				ticket = nil as String?
				match = diff.match(/[+]\[(.*?)\]/)
				if match
					ticket = match[1]
				end

				log = GitIntegration.execute_or_error(
					"git log --stat -n1 #{commit}",
					"Unable to get log for treeish: #{commit}")
				ce = ChangelogEntry.new(ChangelogEntry::UNSPECIFIED,
									"", # description
									ticket,
									nil as String?,
									[] of String)
				text = ce.to_json + "\n\n" + diff + "\n\n" + log
				json = get_edited_text(text)
				ce = ChangelogEntry.from_json(json)
				puts ce.to_json

				# Exit early for testing
				exit 0
			end
			last_commit = commit
		end
	end

	def get_diff(treeish_a : String, treeish_b : String) : String
		diff = GitIntegration.execute_or_error(
			"git diff #{treeish_a} #{treeish_b} CHANGELOG.md | egrep -v 'CHANGELOG.md|index|@@'",
			"Unable to retrieve diff for #{treeish_a} #{treeish_b}")
	end

	# returns list of commits from oldest to newest
	def get_changelog_commits() : Array(String)
		commits = GitIntegration.execute_or_error(
			"git log --reverse --format=%H CHANGELOG.md",
			"Unable to retrieve commits to CHANGELOG.md"
		)
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
end

cm = ChangelogMigrator.new()
cm.run()
