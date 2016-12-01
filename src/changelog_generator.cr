require "semantic_version"
require "./git_integration"
require "./cli_tool"

class ChangelogGenerator
	include CliTool
	@config : ChangelogConfig
	HISTORICAL_CHANGELOG_FILENAME= "CHANGELOG.md"
	def initialize()
		changelog_database = get_changelog_db(get_called_from())
		@config = changelog_database.get_config()
		# used for the ChangelogEntry objects to know how to calculate urls
	end
	def generate( version : String? , with_tags : Set(String))
		semver_tags = get_semver_tags(version)
		process_changelog_files(semver_tags, with_tags)
	end
	def puts_header(version : String?)
		puts "# Changelog\n"
		if version.nil?
			puts "## Unreleased\n"
		end
	end
	def process_changelog_files(semver_tags : Array(String), with_tags : Set(String))

		first_commit = GitIntegration.get_first_commit()
		#FIXME... won't catch changelog in first commit
		# not sure how to fix this, from a git perspective
		semver_tags.push(first_commit)
		semver_tags.unshift("HEAD")
		tags_to_changelog_entries = generate_tags_to_entries_hash(semver_tags)
		tags_to_changelog_entries = remove_edits(semver_tags,
												 tags_to_changelog_entries)
		
		generate_entries(semver_tags, with_tags, tags_to_changelog_entries)
	end

	def generate_tags_to_entries_hash(semver_tags : Array(String)) : Hash(Array(String), Array(String))
		tags_to_changelog_entries = {} of Array(String) => Array(String)
		last_tag = nil
		semver_tags.each do |tag|
			if ! last_tag.nil?
				tags_to_changelog_entries[[last_tag.to_s, tag]] =
					get_changelog_files_between_tags(last_tag.to_s, tag)
				#generate_entry_for_tag_range(last_tag.to_s, tag)
			end
			last_tag = tag
		end
		return tags_to_changelog_entries
	end

	def remove_edits(semver_tags : Array(String), tags_to_entries : Hash(Array(String), Array(String))) : Hash(Array(String), Array(String))

		used_entries = Set(String).new()
		last_tag = nil
		# we're going oldest to newest now
		semver_tags.reverse.each do |tag|
			if ! last_tag.nil?
				entries = tags_to_entries[[tag, last_tag.to_s]]
				entries.each do | entry | 
					if ! used_entries.includes? entry
						used_entries.add(entry)
					else 
						# That was used in an older commit
						tags_to_entries[
							[tag, last_tag.to_s]
						].delete(entry)
					end
				end
			end
			last_tag = tag
		end
		return tags_to_entries
	end


	def generate_entries(semver_tags : Array(String), 
						 with_tags : Set(String),
						 tags_to_entries : Hash(Array(String), Array(String)))
		with_tags_arry = with_tags.to_a
		last_tag  = nil # String?
		semver_tags.each do | tag | 
			if ! last_tag.nil? 
				tag_date = ""
				if last_tag != "HEAD"
					tag_date = GitIntegration.get_tag_date(last_tag).sub(/T.*/, "")
					puts "## [#{last_tag.sub(/^v/, "")}] - #{tag_date}"
				else
					puts "## [Unreleased]"
				end

				changelog_files = tags_to_entries[[last_tag.to_s, tag]]
				changelog_entries = [] of ChangelogEntry
				changelog_files.each do |cf|
					if File.exists? cf
						# it's possible that they added one then removed it later
						ce = ChangelogEntry.from_json(File.read(cf))
						if is_usable_entry?(ce, with_tags_arry)
							changelog_entries <<  ce
						end
					end
				end
				process_entries_by_section(changelog_entries)
			end
			last_tag = tag
		end
	end

	def is_usable_entry?(ce : ChangelogEntry, with_tags_arry : Array(String))
		return (with_tags_arry.empty? || ce.tags.empty? || ce.contains_tags? with_tags_arry)
	end
	def process_entries_by_section(entries : Array(ChangelogEntry))
		ChangelogEntry::CHANGE_TYPES_ARRAY.each do |section|
			select_and_put_entries_for_section(section, entries)
		end
	end

	def select_and_put_entries_for_section(section : String, entries : Array(ChangelogEntry))
		sub_entries = select_entries_for_section(section, entries)
		puts_entries_for_section(section, sub_entries)
	end
	def select_entries_for_section(section : String, entries : Array(ChangelogEntry))
		return entries.select{|ce| ce.type == section}
	end
	def puts_entries_for_section(section_name : String, 
								 entries : Array(ChangelogEntry))

		if entries.size > 0
			puts "### #{section_name}"
			entries.each do |entry|
				puts "* #{entry.to_md(@config)}"
				# calling @config here feels like a hack
			end
			puts ""
		end
	end

	def get_changelog_files_between_tags(tag_a : String, tag_b : String) : Array(String)
		files = GitIntegration.get_files_between_tags(tag_a, tag_b)
		sub_changelog_files = files.select{|f|
			f.starts_with?(".changelog_entries") && ! f.ends_with? "config.json"
		}
		if files.includes? HISTORICAL_CHANGELOG_FILENAME
			# damn it.
			# Support for oldschool commits to CHANGELOG.md
			# that have had changelog entries generated for them...possibly
			hash_to_string_array = GitIntegration.get_files_and_treishes_between_tags(tag_b,
															   tag_a)
			hash_to_string_array.keys.each do |treeish|
				hash_files = hash_to_string_array[treeish]
				if hash_files.includes? HISTORICAL_CHANGELOG_FILENAME
					sub_changelog_files << ".changelog_entries/#{treeish}.json"
					# these may, or may not, exist in the filesystem
				end
			end
		end
		return sub_changelog_files
	end
	# Returns all the semver tags up to version (if specified) 
	# sorted from highest to lowest.
	def get_semver_tags(version : String?) : Array(String)
		tags = get_all_semver_tags() # Hash(SemanticVersion, String)
		if ! version.nil?
			tags = limit_tags(tags, version.to_s)
		end
		result = [] of String
		tags.keys.sort.reverse.each do | sv | 
			result << tags[sv]
		end
		return result
	end

	def get_all_semver_tags(raw_tags : Array(String) = [] of String) : Hash(SemanticVersion, String)
		tags = {} of SemanticVersion => String
		if raw_tags.empty?
			raw_tags = GitIntegration.get_tags()
		end
		raw_tags.each do |tag|
			if ! tag.match(/^[v0-9]/).nil?
				new_tag = tag.starts_with?("v") ? tag.sub(/^v/, "") : tag
				begin 
					sv = SemanticVersion.parse(new_tag)
					tags[sv] = tag
				rescue ArgumentError
					# Skip it.
				end # no rescue. don't care.
			end
		end
		return tags
	end

	def limit_tags(tags : Hash(SemanticVersion, String), version : String) : Hash(SemanticVersion, String)
		limited_tags = {} of SemanticVersion => String
		limit = SemanticVersion.parse(version)
		valid_semver = tags.keys.select{|x| x <= limit}
		valid_semver.each do | vs | 
			limited_tags[vs] = tags[vs]
		end
		return limited_tags
	end
end
