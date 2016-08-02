require "./changelog_config"
class ChangelogDatabase
	getter :found_path
	def initialize(@launch_dir : String)
		@found_path = nil as String?
	end
	def create_default_folder()
		new_found_path = get_possible_entries_path_for_dir(@launch_dir)
		Dir.mkdir(new_found_path)
		@found_path = new_found_path
	end
	def get_config()
		if ! @found_path
			create_default_folder()
		end
		config_file_path = File.join([@found_path.to_s, "config.json"])
		return find_or_create_config(config_file_path)
	end

	def find_or_create_config(config_file_path : String) : ChangelogConfig
		if File.exists? config_file_path
			cc = ChangelogConfig.from_json(File.read(config_file_path))
			## auto-upgrade with new options:
			save_changelog_config(cc, config_file_path)
			return cc
		else
			cc = ChangelogConfig.new()
			save_changelog_config(cc, config_file_path)
			return cc
		end
	end

	def save_changelog_config(cc : ChangelogConfig, config_file_path : String)
		begin
			cc.write_to(config_file_path)
			 GitIntegration.add_file(config_file_path)
		rescue e
			STDERR.puts("Unable to save config file to: #{config_file_path}")
			STDERR.puts("#{e.message}")
		end
	end

	def dot_changelog_entries_path() : String?
		dirs = @launch_dir.split(File::SEPARATOR_STRING)
		last_index = dirs.size() -1
		(0..last_index).each do | idx |
			path = File.join(dirs[0..(last_index - idx)])
			if dir_contains_dot_changelog_entries(path)
				@found_path = get_possible_entries_path_for_dir(path)
				return @found_path
			end
		end
		return nil
	end

	def get_possible_entries_path_for_dir(dir_path) : String
		return File.join([dir_path, ".changelog_entries"])
	end
	
	def dir_contains_dot_changelog_entries(path) : Bool
		possible_entries_path = get_possible_entries_path_for_dir(path)
		return File.exists?(possible_entries_path)
	end
end
