class GitIntegration

	def self.add_file(file_path, changelog_entry : ChangelogEntry) : Bool
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
		files = [] of String
		result = execute_or_error("git diff --name-only #{tag_a} #{tag_b}",
				"Unable to determine files between tags #{tag_a} & #{tag_b}")
		return result.split("\n").uniq
	end

	def self.get_first_commit()
		return execute_or_error("git rev-list --max-parents=0 HEAD",
								  "Unable to determine first commit")
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
		good_io = MemoryIO.new
		bad_io = MemoryIO.new
		status = Process.run(command, shell: true, 
					 	 	 output: good_io,
					 	 	 error: bad_io)
		output = status.exit_code == 0 ? good_io.to_s : bad_io.to_s
		return [status.exit_code, output]
	end

end
