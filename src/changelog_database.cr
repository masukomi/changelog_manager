class ChangelogDatabase
	
	def initialize(@launch_dir : String)
		@found_path as String?
	end
	def create_default_folder()
		Dir.mkdir(get_possible_entries_path_for_dir(@launch_dir))
	end
	def dot_changelog_entries_path() : String?
		dirs = @launch_dir.split(File::SEPARATOR_STRING)
		last_index = dirs.size() -1
		(0..last_index).each do | idx |
			path = dirs[0..(last_index - idx)].join("/")
			if dir_contains_dot_changelog_entries(path)
				@found_path = get_possible_entries_path_for_dir(path)
				return @found_path
			end
		end
		return nil
	end

	def get_possible_entries_path_for_dir(dir_path) : String
		return "#{dir_path}#{File::SEPARATOR_STRING}.changelog_entries"
	end
	def dir_contains_dot_changelog_entries(path) : Bool
		possible_entries_path = get_possible_entries_path_for_dir(path)
		return File.exists?(possible_entries_path)
	end
end
