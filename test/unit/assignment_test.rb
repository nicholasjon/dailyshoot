require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  
  test "create with blank text should fail" do
    assert_no_difference "Assignment.count" do
      assignment = new_assignment :text => ""
      assert !assignment.valid?
    end
  end
  
  test "create with blank tag should fail" do
    assert_no_difference "Assignment.count" do
      assignment = new_assignment :tag => ""
      assert !assignment.valid?
    end
  end
  
  test "create with no date should fail" do
    assert_no_difference "Assignment.count" do
      assignment = new_assignment :date => nil
      assert !assignment.valid?
    end
  end
  
private

  def new_assignment(options={})
    options = {
      :text => "Test Assignment",
      :tag  => "ds100",
      :date => Time.now
    }.merge(options)

    Assignment.create(options)
  end

end
