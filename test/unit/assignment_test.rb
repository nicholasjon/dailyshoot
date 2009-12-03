require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase

  test "should have three published assignments" do
    assignments = Assignment.published
    
    assert_equal 3, assignments.size
    assert_equal assignments(:today), assignments[0]
    assert_equal assignments(:ds10), assignments[1]
    assert_equal assignments(:ds1), assignments[2]
  end

  test "should have one today assignment" do
    assignment = Assignment.today
    
    assert_equal assignments(:today), assignment
  end

  test "should have one upcoming assignment" do
    assignments = Assignment.upcoming
    
    assert_equal 1, assignments.size
    assert_equal assignments(:future), assignments[0]
  end
  
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
  
  test "find photos with photogs should load photos" do
    photos = assignments(:ds10).photos.with_photog
    assert photos.include?(photos(:bestcam))
    photo = photos.detect { |p| p == photos(:bestcam) }
    assert_equal photogs(:joe).screen_name, photo.photog_screen_name
  end
  
  test "displaying as tweet should generated proper format" do
    assert_equal "2009/11/25: Let's play with movement today. Get a shot of something in motion. Freeze it or let it blur. It's up to you! #ds10", 
                 assignments(:ds10).as_tweet
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
