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
end
