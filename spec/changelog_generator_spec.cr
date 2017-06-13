require "./spec_helper"

describe ChangelogGenerator do
	describe "not reusing entries" do
		it "should remove edits from semver pairs" do
			semver_tags = ["v1.0.0", "v0.0.9", "v0.0.8"]
			tag_pairs_to_entries = {
				["v1.0.0", "v0.0.9"] => [".changelog_entries/orig.json",
										".changelog_entries/edit.json"],
										# ^^ edit.json edited here
				["v0.0.9", "v0.0.8"] => [".changelog_entries/orig2.json",
										".changelog_entries/edit.json"]
										# ^^ edit.json created here
			}

			cg = ChangelogGenerator.new()
			trimmed_pairs_to_entries = cg.remove_edits(semver_tags,
												   	   tag_pairs_to_entries)

			### IF I HAD A BEFORE_EACH
			### I'd break these into individual it blocks... grr
			# it should contain the same keys
			trimmed_pairs_to_entries.keys.should(eq(tag_pairs_to_entries.keys))
			trimmed_pairs_to_entries[["v1.0.0",
				  "v0.0.9"]].should(eq([".changelog_entries/orig.json"]))
		end
	end

	describe "choosing valid git tags" do 
		it "should exclude non semver tags" do
			test_tags = ["a", "1.2.3", "v1.2.4", "2.4b"]
			cg = ChangelogGenerator.new()
			parsed_tags = cg.get_all_semver_tags(test_tags).keys.map{|k|k.to_s}
			parsed_tags.should(eq(["1.2.3", "1.2.4"]))
		end
	end
	describe "choosing valid entries" do
		it "should not use entries with unspecified tags" do
			cg = ChangelogGenerator.new()
			ce = ChangelogEntry.new("Changed", "foo", ["4"], "http://example.com/4",
										["foo", "bar", "baz"])

			cg.is_usable_entry?(ce, ["beedle"]).should(eq(false))
		end

		it "should use entries with specified tags" do
			cg = ChangelogGenerator.new()
			ce = ChangelogEntry.new("Changed", "foo", ["4"], "http://example.com/4",
										["foo", "bar", "baz"])

			cg.is_usable_entry?(ce, ["bar"]).should(eq(true))
		end

		it "should use entries with any tag when no tag specified" do
			cg = ChangelogGenerator.new()
			ce = ChangelogEntry.new("Changed", "foo", ["4"], "http://example.com/4",
										["foo", "bar", "baz"])

			cg.is_usable_entry?(ce, [] of String).should(eq(true))
		end

		it "should use entries with no tags regardless of specified tags" do
			cg = ChangelogGenerator.new()
			ce = ChangelogEntry.new("Changed", "foo", ["4"], "http://example.com/4",
										[] of String )

			cg.is_usable_entry?(ce, ["foo", "bar", "baz"]).should(eq(true))
		end

	end
end
