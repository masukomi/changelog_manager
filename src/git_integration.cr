require "io/memory.cr"

class GitIntegration

	def self.add_file(file_path : String) : Bool
		add      = "git add #{file_path}"
		commands = [add]
		# There were more. There may be more again...
		commands.each do | command | 
			response = execute_command(command)
			if response[0] != 0
				raise "Problem shelling out to git: #{response[1]}"
			end
		end
		return true
	end
	
	def self.get_tags() : Array(String)
		result = execute_or_error("git tag", "Unable to acquire tags from git")
		return result.split("\n")
	end

	def self.get_files_between_tags(tag_a : String, tag_b : String) : Array(String)
		result = execute_or_error("git diff --name-only #{tag_a} #{tag_b}",
				"Unable to determine files between tags #{tag_a} & #{tag_b}")
		return result.split("\n").uniq
	end

	# tag_a MUST preceed tag_b temporally or this won't work
	def self.get_files_and_treishes_between_tags(tag_a : String,
												 tag_b : String) : Hash(String,  Array(String))
		log_lines = get_log_between_tags(tag_a, tag_b)
		return self.process_logs(log_lines)
	end
	
	def self.process_logs(log_lines) : Hash(String,  Array(String))
		result = {} of String => Array(String)

		# 3b7fbaf61859fd422f3e9d3f44e5ffda7b9666ef
        #
 	 	#  .changelog_entries/577196bd9b7e58e214a9552749103ca8.json | 1 +
 	 	#  baz.txt                                                  | 1 -
 	 	#  2 files changed, 1 insertion(+), 1 deletion(-)
		
		last_treeish = ""

		log_lines.each do |line|
			if line.match(/^[a-f0-9]{40}$/)
				last_treeish = line
			end
			match = line.match(/^\s+(\S+)\s+\|\s+\d+ [+\-]+$/)
			if last_treeish != "" && match

				if ! result.has_key? last_treeish
					result[last_treeish] = [] of String
				end
				result[last_treeish] << match[1]
			end
		end
		return result
	end

	def self.get_log_between_tags(tag_a : String, tag_b : String) : Array(String)
		return execute_or_error("git log --stat --format=%H #{tag_a}..#{tag_b}",
								 "Unable to read log for #{tag_a}..#{tag_b}" ).split("\n")
	end

	# def self.get_treishes_between_tags(tag_a : String,
	# 									tag_b : String,
	# 									file_matcher : String) : Array(String)
	# 	result = execute_or_error(
	# 		"git log --format=%H #{tag_a}..#{tag_b} #{file_matcher}",
	# 		"Unable to retrieve treeishes between tags #{tag_a} & #{tag_b} for #{file_matcher}")
	# 	return result.split("\n")
	# end

	def self.get_first_commit()
		return execute_or_error("git rev-list --max-parents=0 HEAD",
						  "Unable to determine first commit").sub("\n", "")
	end

	def self.get_tag_date(tag : String)
		return execute_or_error("git log -1 --format=%aI #{tag}",
								"Unable to find date of tag: #{tag}")
	end

	def self.execute_or_error(command, error) : String
		result = execute_command(command)
		if result[0] == 0
			return result[1].to_s # to_s to satisfy compiler
		else
			raise error
		end
	end
	def self.execute_command(command) : Array(Int32 | String)
		good_io = IO::Memory.new
		bad_io = IO::Memory.new
		status = Process.run(command, shell: true, 
					 	 	 output: good_io,
					 	 	 error: bad_io)
		output = status.exit_code == 0 ? good_io.to_s : bad_io.to_s
		return [status.exit_code, output]
	end

end
