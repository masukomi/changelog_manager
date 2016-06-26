require "json"

class ChangelogEntry
	def initialize(@description : String,
				   @ticket      : String?,
				   @url         : String?,
				   @tags        : Array(String))
	end
	
	# the following lets us ingest and expel json
	JSON.mapping({
		ticket: {type: String, nillable: true},
		url: {type: String, nillable: true},
		description: String,
		tags: Array(String)
	})
end


