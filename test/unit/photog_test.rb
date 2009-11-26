require 'test_helper'

class PhotogText < ActiveSupport::TestCase
  
  test "create with blank screen_name should fail" do
    assert_no_difference "Photog.count" do
      photog = new_photog :screen_name => ""
      assert !photog.valid?
    end
  end
  
  test "create with blank name should fail" do
    assert_no_difference "Photog.count" do
      photog = new_photog :name => ""
      assert !photog.valid?
    end
  end
  
private

  def new_photog(options={})
    options = {
      :screen_name => "@screen_name",
      :name        => "Name"
    }.merge(options)

    Photog.create(options)
  end

end
