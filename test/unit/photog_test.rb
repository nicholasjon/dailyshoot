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
  
  test "identify with a new Twitter user should create new record" do
    twitter_user = stub_mentions.first.user

    assert_difference "Photog.count" do
      photog = Photog.for_twitter_user(twitter_user)
      assert_equal "clarkware", photog.screen_name
      assert_equal "Mike Clark", photog.name
    end
  end

  test "identify with an existing Twitter user should not create new record" do
    twitter_user = stub_mentions.first.user
    twitter_user.screen_name = photogs(:joe).screen_name
    
    assert_no_difference "Photog.count" do
      photog = Photog.for_twitter_user(twitter_user)
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
