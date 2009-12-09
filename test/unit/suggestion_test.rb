require 'test_helper'

class SuggestionTest < ActiveSupport::TestCase
  
  test "create with blank name should fail" do
    assert_no_difference "Suggestion.count" do
      suggestion = new_suggestion :name => ""
      assert !suggestion.valid?
    end
  end
  
  test "create with blank user name should fail" do
    assert_no_difference "Suggestion.count" do
      suggestion = new_suggestion :twitter_user_name => ""
      assert !suggestion.valid?
    end
  end
  
  test "create with blank suggestion should fail" do
    assert_no_difference "Suggestion.count" do
      suggestion = new_suggestion :suggestion => ""
      assert !suggestion.valid?
    end
  end
  
private

  def new_suggestion(options={})
    options = {
      :name  => "@clarkware",
      :twitter_user_name => "@clarkware",
      :suggestion => "Here's a suggestion..."
    }.merge(options)

    Suggestion.create(options)
  end

end
