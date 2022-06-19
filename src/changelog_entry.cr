require "json"
require "digest/md5"
require "json_mapping"

class ChangelogEntry

	ADDED       = "Added"
	CHANGED     = "Changed"
	FIXED       = "Fixed"
	DEPRECATED  = "Deprecated"
	REMOVED     = "Removed"
	SECURITY    = "Security"
	UNSPECIFIED = "Unspecified"
	# ^^^ Used when migrating poor data commited to CHANGELOG.md files
	CHANGE_TYPES_ARRAY = [
		ADDED, CHANGED, FIXED, DEPRECATED, REMOVED, SECURITY, UNSPECIFIED
	]
	CHANGE_TYPES_HASH = Hash.zip((1..7).to_a, CHANGE_TYPES_ARRAY)
	getter :type, :description, :tickets, :url, :tags
	setter :type, :description, :tickets, :url, :tags
	def initialize(@type        : String,
				   @description : String,
				   @tickets     : Array(String),
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
	def export(cd : ChangelogDatabase, custom_uuid = nil.as(String?)) : String
		file_path = File.join([cd.found_path.to_s, 
						 "#{custom_uuid.nil? ? uuid() : custom_uuid}.json"])
		File.write(file_path, self.to_json)
		return file_path
	end
	
	def uuid()
		Digest::MD5.hexdigest(self.to_json)
	end

	def to_md(config : ChangelogConfig? = nil ) : String
		md_string = "#{get_tickets_string(config)} #{@description}"
	end

	def to_s() : String
		return to_md()
	end

	def get_tickets_string(config : ChangelogConfig?) : String
		md_string = ""
		if ! @tickets.empty?
			@tickets.each do |ticket|
				md_string += "[\\[#{ticket}\\]]"
				temp_url = get_ticket_url(ticket, config)
				if ! temp_url.nil?
					md_string += "(#{temp_url})"
				end
			end
		end
		return md_string
	end

	def contains_tags?(query_tags : Array(String))
		return ! matching_tags(query_tags).empty?
	end

	def matching_tags(query_tags : Array(String))
		return (@tags & query_tags)
	end

	# the following lets us ingest and expel json
	JSON.mapping({
		type:        String,
		tickets:     {type: Array(String), default: [] of String},
		url:         {type: String, nilable: true},
		description: String,
		tags:        Array(String)
	})

	private def get_ticket_url(ticket : String, config : ChangelogConfig?) : String?
		if ! @url.nil?
			return @url
		elsif ! config.nil?
			return (config.as(ChangelogConfig)).url_for_ticket(ticket)
		end
		return nil
	end
end


