require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase

  test "past assignment should unpublished" do
    assert assignments(:ds1).published?
  end

  test "future assignment should be unpublished" do
    assert !assignments(:upcoming_1).published?
  end
  
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

  test "should have two upcoming assignments" do
    assignments = Assignment.upcoming
    
    assert_equal 2, assignments.size
    assert_equal assignments(:upcoming_1), assignments[0]
    assert_equal assignments(:upcoming_2), assignments[1]
  end

  test "should use position as the param" do
    assert_equal 1, assignments(:ds1).to_param.to_i
  end
  
  test "create with blank text should fail" do
    assert_no_difference "Assignment.count" do
      assignment = new_assignment :text => ""
      assert !assignment.valid?
    end
  end

  test "create should set position, tag, and date" do
    assert_difference "Assignment.count" do
      assignment = new_assignment
      assignment.save
      
      assignment.reload
      assert_not_nil assignment.position
      assert_equal "ds6", assignment.tag
      assert_not_nil assignment.date
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
  
  test "first upcoming assignment can't be moved higher" do
    assert !assignments(:upcoming_1).can_move_higher
  end
  
  test "last upcoming assignment can be moved higher" do
    assert assignments(:upcoming_2).can_move_higher
  end
  
  test "move assignment up should update positions, tags, and dates" do
    assert_equal 4, assignments(:upcoming_1).position
    assert_equal 5, assignments(:upcoming_2).position
    assert assignments(:upcoming_1).date < assignments(:upcoming_2).date
    
    assert assignments(:upcoming_2).move('up')
    
    assert_equal 4,     assignments(:upcoming_2, :reload).position
    assert_equal 5,     assignments(:upcoming_1, :reload).position
    assert_equal "ds4", assignments(:upcoming_2).tag
    assert_equal "ds5", assignments(:upcoming_1).tag
    assert assignments(:upcoming_2).date < assignments(:upcoming_1).date
  end
  
  test "move assignment down should reorder positions and update tags" do
    assert_equal 4, assignments(:upcoming_1).position
    assert_equal 5, assignments(:upcoming_2).position
    assert assignments(:upcoming_1).date < assignments(:upcoming_2).date
    
    assert assignments(:upcoming_1).move('down')
    
    assert_equal 4, assignments(:upcoming_2, :reload).position
    assert_equal 5, assignments(:upcoming_1, :reload).position
    assert_equal "ds4", assignments(:upcoming_2).tag
    assert_equal "ds5", assignments(:upcoming_1).tag
    assert assignments(:upcoming_2).date < assignments(:upcoming_1).date
  end
  
  test "move last assignment up should not reorder positions or update tags" do
    assert_equal 4, assignments(:upcoming_1).position
    assert_equal 5, assignments(:upcoming_2).position
    assert assignments(:upcoming_1).date < assignments(:upcoming_2).date
    
    assert_nil assignments(:upcoming_1).move('up')
    
    assert_equal 4, assignments(:upcoming_1).position
    assert_equal 5, assignments(:upcoming_2).position
    assert_equal "ds98", assignments(:upcoming_1).tag
    assert_equal "ds99", assignments(:upcoming_2).tag
    assert assignments(:upcoming_1).date < assignments(:upcoming_2).date
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
