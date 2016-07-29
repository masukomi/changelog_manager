require "json"
class ChangelogConfig
	getter :ticket_url_prefix
	def initialize()
		@ticket_url_prefix = nil as String?
		@git_add = true as Bool
	end
	# the following lets us ingest and expel json
	JSON.mapping({
		ticket_url_prefix:  {type: String, nilable: true},
		git_add: {type: Bool, default: true}
	})
end
