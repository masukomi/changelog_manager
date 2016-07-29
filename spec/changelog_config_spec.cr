
require "./spec_helper"

describe ChangelogConfig do

	it "should add git_add to existing configs" do
		old_config = "{\"ticket_url_prefix\" : \"https://github.com/masukomi/changelog_manager/issues/\"}"
		cc = ChangelogConfig.from_json(old_config)
		cc.to_json.includes?("git_add").should(eq(true))
	end
end
