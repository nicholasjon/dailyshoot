require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  test "create should generate thumb url" do
    p = Photo.new(:url => "http://bestc.am/oGuf")
    assert p.save
    assert_not_nil p.thumb_url
  end

  test "tweet without a URL should not be exceptional" do
    tweet = "I've kept 3 shots for today's @dailyshoot. Can't decide which one to use."
    photo = Photo.from_tweet(tweet)
    
    assert_nil photo
  end
  
  test "tweet with URL that isn't a photo should not assign photo" do
    tweet = "Check out http://dailyshoot.com"
    photo = Photo.from_tweet(tweet)

    assert_nil photo
  end
  
  test "tweet with short URL that doesn't expand to a photo should not assign photo" do
    tweet = "http://bit.ly/5msIMo"
    photo = Photo.from_tweet(tweet)

    assert_nil photo
  end
  
  test "tweet with invalid URL should ignore it" do
    tweet = "My first assignment: Water http://bi.. http://bit.ly/6Jp0el"
    url   = "http://www.flickr.com/photos/bg/4131881234/"
    thumb = "http://farm3.static.flickr.com/2589/4131881234_1cb6f072ca_s.jpg"
        
    assert_photo_urls(tweet, url, thumb)
  end
    
  test "tweet with bestc.am URL should assign url and thumb url" do
    tweet  = "http://bestc.am/oGuf Fort Point Channel—Boston. (For @dailyshoot.)"
    url    = "http://bestc.am/oGuf"
    thumb  = "http://s3.amazonaws.com/cjapps/images/143131/thumb.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweet with yfrog URL should assign url and thumb url" do
    tweet  = "@dailyshoot http://yfrog.com/4izptj"
    url    = "http://yfrog.com/4izptj"
    thumb  = "http://yfrog.com/4izptj.th.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweet with twitpic URL should assign url and thumb url" do
    tweet  = "@dailyshoot Ant's eye view for today's assignment. http://twitpic.com/qosz0"
    url    = "http://twitpic.com/qosz0"
    thumb  = "http://twitpic.com/show/thumb/qosz0"
    
    assert_photo_urls(tweet, url, thumb)
  end

  test "tweet with imgur URL should assign url and thumb url" do
    tweet  = "@dailyshoot #ds2 http://imgur.com/TRxN1.jpg"
    url    = "http://imgur.com/TRxN1.jpg"
    thumb  = "http://i.imgur.com/TRxN1s.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweet with snaptweet URL should assign url and thumb url" do
    tweet  = "My @dailyshoot submission for today is 'See Food' http://snaptweet.com/03c12"
    url    = "http://snaptweet.com/03c12"
    thumb  = "http://farm3.static.flickr.com/2754/4117367227_d82460f234.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweet with pnt.me URL should expand url" do
    tweet  = "@dailyshoot 11/24 - http://pnt.me/Sr6q0Z"
    url    = "http://www.flickr.com/photos/spaceplatypus/4131695975/"

    assert_photo_url_expands(tweet, url)
  end
  
  test "tweet with pnt.me URL should assign url and thumb url" do
    tweet  = "@dailyshoot 11/24 - http://pnt.me/Sr6q0Z"
    url    = "http://www.flickr.com/photos/spaceplatypus/4131695975/"
    thumb  = "http://farm3.static.flickr.com/2538/4131695975_6db349916a_s.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweet with tr.im URL should expand url" do
    tweet  = "@dailyshoot Grate Lake http://tr.im/FI9n"
    url    = "http://www.flickr.com/photos/97151260@N00/4132412954/"

    assert_photo_url_expands(tweet, url)
  end
  
  test "tweet with tr.im URL should assign url and thumb url" do
    tweet  = "@dailyshoot Grate Lake http://tr.im/FI9n"
    url    = "http://www.flickr.com/photos/97151260@N00/4132412954/"
    thumb  = "http://farm3.static.flickr.com/2668/4132412954_516be07418_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweet with j.mp URL should expand url" do
    tweet  = "@dailyshoot Here's my shot for the water assignment. http://j.mp/7zgpjd"
    url    = "http://www.flickr.com/photos/ejknapp/4131597128/in/pool-1251121@N24"

    assert_photo_url_expands(tweet, url)
  end
  
  test "tweet with j.mp should URL should assign url and thumb url" do
    tweet  = "@dailyshoot Here's my shot for the water assignment. http://j.mp/7zgpjd"
    url    = "http://www.flickr.com/photos/ejknapp/4131597128/in/pool-1251121@N24"
    thumb  = "http://farm3.static.flickr.com/2565/4131597128_e04154164f_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end

  test "tweet with bit.ly URL should expand url" do
    tweet  = "@dailyshoot: A low contrast droplet - http://bit.ly/8lfTwJ"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"

    assert_photo_url_expands(tweet, url)
  end
  
  test "tweet with flickr URL should assign url and thumb url" do
    tweet  = "@dailyshoot: A low contrast droplet - http://www.flickr.com/photos/clarkware/4131620353/"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"
    thumb  = "http://farm3.static.flickr.com/2662/4131620353_51affbc130_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end

  test "tweet with flickr set URL should not assign a photo" do
    tweet = "http://flickr.com/ari/sets/72157622699478909/"
    photo = Photo.from_tweet(tweet)
    
    assert_nil photo
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
