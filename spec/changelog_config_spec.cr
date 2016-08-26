require "./spec_helper"
require "json"

describe ChangelogConfig do

	it "should add git_add to existing configs" do
		old_config = "{\"ticket_url_prefix\" : \"https://github.com/masukomi/changelog_manager/issues/\"}"
		cc = ChangelogConfig.from_json(old_config)
		cc.to_json.includes?("git_add").should(eq(true))
	end

	it "should let you override ticket_prefix" do
		cc = ChangelogConfig.new()
		raw_json = "{\"ticket_url_prefix\" : \"https://github.com/masukomi/changelog_manager/issues/\"}"

		json = JSON.parse(raw_json)
		cc.handle_overrides(json)
		cc.ticket_url_prefix.should(eq("https://github.com/masukomi/changelog_manager/issues/"))
	end

	it "should let you override git_add" do
		cc = ChangelogConfig.new()
		raw_json = "{\"git_add\" : false}"

		json = JSON.parse(raw_json)
		cc.handle_overrides(json)
		cc.git_add.should(eq(false))

	end

	it "should generate an url for a ticket when ticket_url_prefix is set" do
		cc = ChangelogConfig.new()
		cc.ticket_url_prefix = "http://foo.com/"
		cc.url_for_ticket("1234").should(eq("http://foo.com/1234"))
	end

	it "should not generate an url for a ticket when ticket_url_prefix isn't set" do
		cc = ChangelogConfig.new()
		cc.url_for_ticket("1234").should(eq(nil))
	end
end
