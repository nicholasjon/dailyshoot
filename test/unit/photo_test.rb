require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  test "tweet without a URL should not be exceptional" do
    tweet = "I've kept 3 shots for today's @dailyshoot. Can't decide which one to use."
    photos = Photo.all_from_tweet(tweet)
    
    assert_equal 0, photos.size
  end

  test "tweet with URL that isn't a photo should not assign photo" do
    tweet = "Check out http://dailyshoot.com"
    photos = Photo.all_from_tweet(tweet)

    assert_equal 0, photos.size
  end
  
  test "tweet with short URL that doesn't expand to a photo should not assign photo" do
    tweet = "http://bit.ly/5msIMo"
    photos = Photo.all_from_tweet(tweet)

    assert_equal 0, photos.size
  end
    
  test "tweet with bestc.am URL should assign url and thumb url" do
    tweet  = "http://bestc.am/oGuf Fort Point Channel—Boston. (For @dailyshoot.)"
    url    = "http://bestc.am/oGuf"
    thumb  = "http://s3.amazonaws.com/cjapps/images/143131/thumb.jpg"
    
    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with yfrog URL should assign url and thumb url" do
    tweet  = "@dailyshoot http://yfrog.com/4izptj"
    url    = "http://yfrog.com/4izptj"
    thumb  = "http://yfrog.com/4izptj.th.jpg"
    
    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with twitpic URL should assign url and thumb url" do
    tweet  = "@dailyshoot Ant's eye view for today's assignment. http://twitpic.com/qosz0"
    url    = "http://twitpic.com/qosz0"
    thumb  = "http://twitpic.com/show/thumb/qosz0"
    
    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with tweetphoto URL should assign url and thumb url" do
    tweet  = "@dailyshoot #ds14 patterns  http://tweetphoto.com/5588888"
    url    = "http://tweetphoto.com/5588888"
    thumb  = "http://cdn.cloudfiles.mosso.com/c54112/x2_554798"
    
    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with imgur URL should assign url and thumb url" do
    tweet  = "@dailyshoot #ds2 http://imgur.com/TRxN1.jpg"
    url    = "http://imgur.com/TRxN1.jpg"
    thumb  = "http://i.imgur.com/TRxN1s.jpg"
    
    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with snaptweet URL should assign url and thumb url" do
    tweet  = "My @dailyshoot submission for today is 'See Food' http://snaptweet.com/03c12"
    url    = "http://snaptweet.com/03c12"
    thumb  = "http://farm3.static.flickr.com/2754/4117367227_d82460f234.jpg"
    
    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with pnt.me URL should assign url and thumb url" do
    tweet  = "@dailyshoot 11/24 - http://pnt.me/Sr6q0Z"
    url    = "http://www.flickr.com/photos/spaceplatypus/4131695975/"
    thumb  = "http://farm3.static.flickr.com/2538/4131695975_6db349916a_s.jpg"
    
    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with tr.im URL should assign url and thumb url" do
    tweet  = "@dailyshoot Grate Lake http://tr.im/FI9n"
    url    = "http://www.flickr.com/photos/97151260@N00/4132412954/"
    thumb  = "http://farm3.static.flickr.com/2668/4132412954_516be07418_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with j.mp should URL should assign url and thumb url" do
    tweet  = "@dailyshoot Here's my shot for the water assignment. http://j.mp/7zgpjd"
    url    = "http://www.flickr.com/photos/ejknapp/4131597128/in/pool-1251121@N24"
    thumb  = "http://farm3.static.flickr.com/2565/4131597128_e04154164f_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with bit.ly URL should expand url" do
    tweet  = "@dailyshoot: A low contrast droplet - http://bit.ly/8lfTwJ"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"
    thumb  = "http://farm3.static.flickr.com/2662/4131620353_51affbc130_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with tinyurl should URL should assign url and thumb url" do
    tweet  = "@dailyshoot http://tinyurl.com/yd9kgxn"
    url    = "http://www.flickr.com/photos/clarkware/4193699212/"
    thumb  = "http://farm3.static.flickr.com/2596/4193699212_147e5a576e_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with tiny.cc should URL should assign url and thumb url" do
    tweet  = "@dailyshoot http://tiny.cc/GrbEf"
    url    = "http://www.flickr.com/photos/tooobi/4183248462/in/pool-1251121@N24"
    thumb  = "http://farm3.static.flickr.com/2742/4183248462_5db53286ce_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end
  
  test "tweet with flickr.com URL should assign url and thumb url" do
    tweet  = "@dailyshoot: A low contrast droplet - http://www.flickr.com/photos/clarkware/4131620353/"
    url    = "http://www.flickr.com/photos/clarkware/4131620353/"
    thumb  = "http://farm3.static.flickr.com/2662/4131620353_51affbc130_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with flic.kr URL should assign url and thumb url" do
    tweet = "@dailyshoot http://flic.kr/p/7iDPb7 #ds11"
    url   = "http://flic.kr/p/7iDPb7"
    thumb = "http://farm3.static.flickr.com/2609/4137898878_2874643ebd_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with flickr static URL should assign url and thumb url" do
    tweet = "@dailyshoot http://farm5.static.flickr.com/4036/4243576772_91ee986470_o.jpg #ds11"
    url   = "http://farm5.static.flickr.com/4036/4243576772_91ee986470_o.jpg"
    thumb = "http://farm5.static.flickr.com/4036/4243576772_91ee986470_s.jpg"

    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with flickr set URL should not assign a photo" do
    tweet = "http://flickr.com/ari/sets/72157622699478909/"
    photos = Photo.all_from_tweet(tweet)
    
    assert_equal 0, photos.size
  end
  
  test "tweet with smugmug URL should assign url and thumb url" do
    tweet = "@dailyshoot http://bluecamel.smugmug.com/Photography/dailyshoot/10469863_EdveS#748954599_NUvea #ds11"
    url   = "http://bluecamel.smugmug.com/Photography/dailyshoot/10469863_EdveS#748954599_NUvea"
    thumb = "http://bluecamel.smugmug.com/Photography/dailyshoot/DSC0717/748954599_NUvea-Ti.jpg"

    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with invalid URL should ignore it" do
    tweet = "My first assignment: Water http://bi.. http://bit.ly/6Jp0el"
    url   = "http://www.flickr.com/photos/bg/4131881234/"
    thumb = "http://farm3.static.flickr.com/2589/4131881234_1cb6f072ca_s.jpg"
        
    assert_one_photo(tweet, url, thumb)
  end

  test "tweet with two photo URLs should assign two photos with url and thumb url" do
    tweet   = "Two @dailyshoot shots: http://flic.kr/p/7hVTxV and http://flic.kr/p/7hZKAJ"
    url_1   = "http://flic.kr/p/7hVTxV"
    thumb_1 = "http://farm3.static.flickr.com/2499/4129718895_2037cd7074_s.jpg"
    url_2   = "http://flic.kr/p/7hZKAJ"
    thumb_2 = "http://farm3.static.flickr.com/2774/4130472594_e7a3519f6b_s.jpg"
    
    photos = Photo.all_from_tweet(tweet)
    assert_equal 2, photos.size
    
    assert_equal url_1, photos[0].url
    assert_equal thumb_1, photos[0].thumb_url

    assert_equal url_2, photos[1].url
    assert_equal thumb_2, photos[1].thumb_url
  end
            
protected

  def assert_one_photo(tweet, url, thumb)
    photos = Photo.all_from_tweet(tweet)
    
    assert_equal 1, photos.size
    
    photo = photos.first
    
    assert_equal url, photo.url
    assert_equal thumb, photo.thumb_url
  end
  
end
