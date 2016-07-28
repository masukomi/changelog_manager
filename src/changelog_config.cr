require "json"
class ChangelogConfig
	getter :ticket_url_prefix
	def initialize()
		@ticket_url_prefix = nil as String?
	end
	# the following lets us ingest and expel json
	JSON.mapping({
		ticket_url_prefix:  {type: String, nilable: true},
	})
end
