require "./spec_helper"

describe ChangelogEntry do
	it "should load json without ticket or url" do
		json = "{\"type\":\"Changed\",\"description\":\"a description\",\"tags\":[]}"
		ce = ChangelogEntry.from_json(json)
		ce.ticket.should(eq(nil))
		ce.url.should(eq(nil))
	end

	it "should load json WITH ticket and url" do
		json = "{\"type\":\"Added\",\"ticket\":\"8\",\"url\":\"https://github.com/masukomi/changelog_manager/issues/8\",\"description\":\"Now derives ticket urls from the provided ID if possible.\",\"tags\":[]}"
		ce = ChangelogEntry.from_json(json)
		ce.ticket.should(eq("8"))
		ce.url.should(eq("https://github.com/masukomi/changelog_manager/issues/8"))
	end

	it "should include square brackets around ticket numbers" do
		ce = ChangelogEntry.new("Changed", 
										"foo",
										"4",
										"http://example.com/4",
										[] of String)
		ce.to_md.starts_with?("[\\[4\\]](http://example.com/4)").should(eq(true))
	end

	it "should indicate if it contains_tags?" do
		ce = ChangelogEntry.new("Changed", 
										"foo",
										"4",
										"http://example.com/4",
										["foo", "bar", "baz"])

		ce.contains_tags?(["bar", "baz"]).should(eq(true))
	end

	it "should indicate if it doesn't contain tags" do
		ce = ChangelogEntry.new("Changed", "foo", "4", "http://example.com/4",
										["foo", "bar", "baz"])

		ce.contains_tags?(["foodle", "fi"]).should(eq(false))

		ce = ChangelogEntry.new("Changed", "foo", "4", "http://example.com/4",
										[] of String)

		ce.contains_tags?(["foodle", "fi"]).should(eq(false))

	end
end
