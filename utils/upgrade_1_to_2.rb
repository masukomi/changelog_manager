#!/usr/bin/env ruby

require 'json'

changelog_entries = Dir.entries(".changelog_entries").select{|x|
	! x.end_with?("config.json") && ! x.start_with?(".") && x.end_with?(".json") }

if changelog_entries.size == 0
	puts "I couldn't find anything in .changelog_entries"
	exit(1)
end

changelog_entries.each do |ce|
	path    = ".changelog_entries/#{ce}"
	puts "Upgrading: #{path}"
	data    = File.read(path)
	json    = JSON.parse(data)
	ticket  = json.delete("ticket")
	url     = json.delete("url")
	tickets = []
	if ! ticket.nil? && ticket.size > 0
		tickets.push(ticket)
	end
	json["tickets"] = tickets
	json["url"] = url # possibly nil

	File.open(path, "w") do |f|
		f.write(json.to_json)
	end
end

puts "DONE"
puts "Please run the following command to add the updates to git"
puts "git add .changelog_entries"
