require "json"
require "crypto/md5"

class ChangelogEntry

	FIXED   = "Fixed"
	CHANGED = "Changed"
	ADDED   = "Added"
	UNSPECIFIED = "Unspecified"
	# ^^^ Used when migrating poor data commited to CHANGELOG.md files

	CHANGE_TYPES = {
		1 => FIXED,
		2 => CHANGED,
		3 => ADDED,
		4 => UNSPECIFIED # Not an option in the UI
	}
	getter :type, :description, :ticket, :url, :tags
	setter :type, :description, :ticket, :url, :tags
	def initialize(@type        : String,
				   @description : String,
				   @ticket      : String?,
				   @url         : String?,
				   @tags        : Array(String))
	end

	# ## Public: export(cd : ChangelogDatabase) : String
	# Adds this entry as a JSON file in the changelog database.
	# 
	# ## Parameters:
	# * cd - A ChangelogDatabase instance
	#
	# ## Returns:
	# The location where the file was written.
	def export(cd : ChangelogDatabase, custom_uuid = nil as String?) : String
		file_path = File.join([cd.found_path.to_s, 
						 "#{custom_uuid.nil? ? uuid() : custom_uuid}.json"])
		File.write(file_path, self.to_json)
		return file_path
	end
	
	def uuid()
		Crypto::MD5.hex_digest(self.to_json)
	end

	def to_md() : String
		md_string = "#{get_ticket_string()} #{@description}"
	end

	def to_s() : String
		return to_md()
	end

	def get_ticket_string() : String
		md_string = ""
		if ! @ticket.nil?
			md_string += "[#{@ticket}]"
			if ! @url.nil?
				md_string += "(#{@url})"
			end
		end
		return md_string
	end

	# the following lets us ingest and expel json
	JSON.mapping({
		type:        String,
		ticket:      {type: String, nillable: true},
		url:         {type: String, nillable: true},
		description: String,
		tags:        Array(String)
	})
end


