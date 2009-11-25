require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  test "bestc.am should parse" do
    tweet  = "http://bestc.am/oGuf Fort Point Channel—Boston. (For @dailyshoot.)"
    url    = "http://bestc.am/oGuf"
    thumb  = "http://s3.amazonaws.com/cjapps/images/143131/thumb.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "yfrog should parse" do
    tweet  = "@dailyshoot http://yfrog.com/4izptj"
    url    = "http://yfrog.com/4izptj"
    thumb  = "http://yfrog.com/4izptj.th.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "twitpic should parse" do
    tweet  = "@dailyshoot Ant's eye view for today's assignment. http://twitpic.com/qosz0"
    url    = "http://twitpic.com/qosz0"
    thumb  = "http://twitpic.com/show/thumb/qosz0"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "snaptweet should parse" do
    tweet  = "My @dailyshoot submission for today is 'See Food' http://snaptweet.com/03c12"
    url    = "http://snaptweet.com/03c12"
    thumb  = "http://farm3.static.flickr.com/2754/4117367227_d82460f234.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "pnt.me should expand" do
    tweet  = "@dailyshoot 11/24 - http://pnt.me/Sr6q0Z"
    url    = "http://www.flickr.com/photos/spaceplatypus/4131695975/"

    assert_photo_url_expands(tweet, url)
  end
  
  test "tr.im should expand" do
    tweet  = "@dailyshoot Grate Lake http://tr.im/FI9n"
    url    = "http://www.flickr.com/photos/97151260@N00/4132412954/"

    assert_photo_url_expands(tweet, url)
  end
  
  test "j.mp should expand" do
    tweet  = "@dailyshoot Here's my shot for the water assignment. http://j.mp/7zgpjd"
    url    = "http://www.flickr.com/photos/ejknapp/4131597128/in/pool-1251121@N24"

    assert_photo_url_expands(tweet, url)
  end

  test "bit.ly should expand" do
    tweet  = "@dailyshoot: A low contrast droplet - http://bit.ly/8lfTwJ"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"

    assert_photo_url_expands(tweet, url)
  end
  
protected

  def assert_photo_urls(tweet, url, thumb)
    photo = Photo.from_tweet(tweet)
    
    assert_equal url, photo.url
    assert_equal thumb, photo.thumb_url
  end
  
  def assert_photo_url_expands(tweet, url)
    photo = Photo.from_tweet(tweet)
    
    assert_equal url, photo.url
  end
  
end