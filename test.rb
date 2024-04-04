require_relative 'byechef'

require 'minitest/spec'
require 'minitest/autorun'

describe "test for categorizing a GitHub repo" do
  before do
    @calculated = calculate_percentages(
     categorize(
      to_list(
       get_repositories_for(
        get_github_profile('https://fullstackplus.tech/')
        )
       )
      )
     )
  end

  it "calculates the right percentages" do
    _(@calculated.values).must_equal [7, 40, 53]
  end
end
