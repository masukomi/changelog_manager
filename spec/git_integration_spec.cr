require "./spec_helper"

describe GitIntegration do
	describe "log parsing (ugh)" do
		it "extracts a hash of files per treeish" do
			raw_log="970a6849bb82a67006fe5d81e2efdbc98f03b24f

 CHANGELOG.md | 2 ++
 1 file changed, 2 insertions(+)
f4a77ca4fead4808794f4a67e3b0c31f194e6574

 CHANGELOG.md | 3 +++
 1 file changed, 3 insertions(+)
4ecdbd15a01cdba40ce8f88e0ab35608dd8c02c3

 CHANGELOG.md | 3 +++
 1 file changed, 3 insertions(+)".split("\n")
 
			expected_result = {
				"970a6849bb82a67006fe5d81e2efdbc98f03b24f" => [
					"CHANGELOG.md"
				],
				"f4a77ca4fead4808794f4a67e3b0c31f194e6574" => [
					"CHANGELOG.md"
				],
				"4ecdbd15a01cdba40ce8f88e0ab35608dd8c02c3" => [
					"CHANGELOG.md"
				],

			}
 			GitIntegration.process_logs(raw_log).should(eq(expected_result))
		end
	end
end
