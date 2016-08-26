require "json"
class ChangelogConfig
	getter :ticket_url_prefix, :git_add
	def initialize()
		@ticket_url_prefix = nil as String?
		@git_add = true as Bool
	end

	def url_for_ticket(ticket : String) : String?
		if ! @ticket_url_prefix.nil? 
			return "#{ticket_url_prefix}#{ticket}"
		else
			return nil
		end
	end

	def handle_overrides( overrides : JSON::Any)
		@ticket_url_prefix = (overrides["ticket_url_prefix"].to_s rescue nil) || 
			@ticket_url_prefix
		temp_add = overrides["git_add"].as_bool rescue nil
		@git_add = temp_add.nil? ? @git_add : temp_add
	end

	def write_to(path : String)
		File.write(path, self.to_json)
	end

	# the following lets us ingest and expel json
	JSON.mapping({
		ticket_url_prefix:  {type: String, nilable: true},
		git_add: {type: Bool, default: true}
	})
end
