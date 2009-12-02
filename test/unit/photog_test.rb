require 'test_helper'

class PhotogText < ActiveSupport::TestCase
  
  test "create with blank screen_name should fail" do
    assert_no_difference "Photog.count" do
      photog = new_photog :screen_name => ""
      assert !photog.valid?
    end
  end

  test "identify with a new Twitter user should return new record" do
    twitter_user = stub_mentions.first.user
    photog = Photog.with_screen_name(twitter_user.screen_name)
    
    assert photog.new_record?
  end

  test "identify with an existing Twitter should find existing record" do
    twitter_user = stub_mentions.first.user
    twitter_user.screen_name = photogs(:joe).screen_name
    photog = Photog.with_screen_name(twitter_user.screen_name)

    assert_equal photogs(:joe), photog
  end
  
private

  def new_photog(options={})
    options = {
      :screen_name        => "@screen_name",
      :profile_image_url  => "image url"
    }.merge(options)

    Photog.create(options)
  end

end
