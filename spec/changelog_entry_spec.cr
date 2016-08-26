require "./spec_helper"

describe ChangelogEntry do
	# it "should load json without ticket or url" do
	# 	json = "{\"type\":\"Changed\",\"description\":\"a description\",\"tags\":[]}"
	# 	ce = ChangelogEntry.from_json(json)
	# 	ce.tickets.should(eq([] of String))
	# 	ce.url.should(eq(nil))
	# end

	it "should load json WITH a ticket and url" do
		json = "{\"type\":\"Added\",\"tickets\":[\"8\"],\"url\":\"https://github.com/masukomi/changelog_manager/issues/8\",\"description\":\"Now derives ticket urls from the provided ID if possible.\",\"tags\":[]}"
		ce = ChangelogEntry.from_json(json)
		ce.tickets.first.should(eq("8"))
		ce.url.should(eq("https://github.com/masukomi/changelog_manager/issues/8"))
	end

	it "should include square brackets around ticket number" do
		ce = ChangelogEntry.new("Changed", 
										"foo",
										["4"],
										"http://example.com/4",
										[] of String)
		ce.to_md.starts_with?("[\\[4\\]]").should(eq(true))
	end

	it "should include multiple ticket numbers" do
		ce = ChangelogEntry.new("Changed", 
										"foo",
										["4", "5"],
										nil,
										[] of String)
		ce.to_md.starts_with?("[\\[4\\]][\\[5\\]]").should(eq(true))
	end

	it "should indicate if it contains_tags?" do
		ce = ChangelogEntry.new("Changed", 
										"foo",
										["4"],
										"http://example.com/4",
										["foo", "bar", "baz"])

		ce.contains_tags?(["bar", "baz"]).should(eq(true))
	end

	it "should indicate if it doesn't contain tags" do
		ce = ChangelogEntry.new("Changed", "foo", ["4"], "http://example.com/4",
										["foo", "bar", "baz"])

		ce.contains_tags?(["foodle", "fi"]).should(eq(false))

		ce = ChangelogEntry.new("Changed", "foo", ["4"], "http://example.com/4",
										[] of String)

		ce.contains_tags?(["foodle", "fi"]).should(eq(false))

	end
end
