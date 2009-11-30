require 'test_helper'

class SuggestionTest < ActiveSupport::TestCase
  
  test "create with blank what should fail" do
    assert_no_difference "Suggestion.count" do
      suggestion = new_suggestion :what => ""
      assert !suggestion.valid?
    end
  end
  
private

  def new_suggestion(options={})
    options = {
      :who  => "@clarkware",
      :what => "Here's a suggestion..."
    }.merge(options)

    Suggestion.create(options)
  end

end
