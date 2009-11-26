require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  test "create should generate thumb url" do
    p = Photo.new(:url => "http://bestc.am/oGuf")
    assert p.save
    assert_not_nil p.thumb_url
  end
  
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
    thumb  = "http://farm3.static.flickr.com/2538/4131695975_6db349916a_s.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "pnt.me should parse" do
    tweet  = "@dailyshoot 11/24 - http://pnt.me/Sr6q0Z"
    url    = "http://www.flickr.com/photos/spaceplatypus/4131695975/"
    thumb  = "http://farm3.static.flickr.com/2538/4131695975_6db349916a_s.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tr.im should expand" do
    tweet  = "@dailyshoot Grate Lake http://tr.im/FI9n"
    url    = "http://www.flickr.com/photos/97151260@N00/4132412954/"
    thumb  = "http://farm3.static.flickr.com/2668/4132412954_516be07418_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tr.im should parse" do
    tweet  = "@dailyshoot Grate Lake http://tr.im/FI9n"
    url    = "http://www.flickr.com/photos/97151260@N00/4132412954/"
    thumb  = "http://farm3.static.flickr.com/2668/4132412954_516be07418_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end
  
  test "j.mp should expand" do
    tweet  = "@dailyshoot Here's my shot for the water assignment. http://j.mp/7zgpjd"
    url    = "http://www.flickr.com/photos/ejknapp/4131597128/in/pool-1251121@N24"
    thumb  = "http://farm3.static.flickr.com/2565/4131597128_e04154164f_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end
  
  test "j.mp should parse" do
    tweet  = "@dailyshoot Here's my shot for the water assignment. http://j.mp/7zgpjd"
    url    = "http://www.flickr.com/photos/ejknapp/4131597128/in/pool-1251121@N24"
    thumb  = "http://farm3.static.flickr.com/2565/4131597128_e04154164f_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end

  test "bit.ly should expand" do
    tweet  = "@dailyshoot: A low contrast droplet - http://bit.ly/8lfTwJ"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"
    thumb  = "http://farm3.static.flickr.com/2662/4131620353_51affbc130_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end
  
  test "bit.ly should parse" do
    tweet  = "@dailyshoot: A low contrast droplet - http://bit.ly/8lfTwJ"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"
    thumb  = "http://farm3.static.flickr.com/2662/4131620353_51affbc130_s.jpg"

    assert_photo_urls(tweet, url, thumb)
  end
  
  test "tweets without URLs aren't exceptional" do
    tweet = "I've kept 3 shots for today's @dailyshoot. Can't decide which one to use. grumble."
    photo = Photo.from_tweet(tweet)
    
    assert_nil photo
  end
  
  test "URL with link that isn't to a photo" do
    tweet = "Really enjoying seeing what people contribute to @dailyshoot every day.  Here's the Flickr crowd: http://bit.ly/1zSBG5"
    url   = "http://www.flickr.com/groups/1251121@N24/pool/"
    thumb = nil
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  # Do we even want to recognize something like this?
  test "URL to a flickr set" do
    tweet = "Today's @dailyshoot is street or sidewalk scene Mostly red #dailyshoot photos I took Monday http://flickr.com/ari/sets/72157622699478909/"
    url   = "http://flickr.com/ari/sets/72157622699478909/"
    thumb = "http://farm3.static.flickr.com/2658/4112081661_5074093236_s.jpg"
    
    assert_photo_urls(tweet, url, thumb)
  end
  
  test "correctly parse URLs" do
    tweet = "Just joined @dailyshoot after watching @dlnorman have so much fun with it. My first assignment: Water http://bi.. http://bit.ly/5msIMo"
    url   = "http://twitter.com/bgblogging/statuses/6018151103"
    
    assert_photo_url_expands(tweet, url)
  end
  
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