require "./spec_helper"

class CliToolConcrete
	include CliTool
	
end


describe CliTool do
	

	it "should get_change_type_answers_list" do
		expected = (1..8).map{|x|x.to_s}
		ctr = CliToolConcrete.new()
		ctr.get_change_type_answers_list().should(eq(expected))
	end
	it "should get_change_type_questions_string" do
		expected = "What kind of Change?
1 - Added
2 - Changed
3 - Fixed
4 - Deprecated
5 - Removed
6 - Security
7 - Unspecified
8 - Quit. No entry please.
[1, 2, 3, 4, 5, 6, 7, 8]: "
		ctr = CliToolConcrete.new()
		ctr.get_change_type_questions_string().should(eq(expected))
	end
	it "should convert comma separated list to array" do
		ctr = CliToolConcrete.new()
		list = "foo, bar , ,, baz"
		ctr.convert_comma_list_to_array(list).should(eq(
			["foo", "bar", "baz"]))
	end

end
