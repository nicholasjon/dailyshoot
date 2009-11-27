require 'test_helper'

class TweetTest < ActiveSupport::TestCase

  test "tweet with hashtag should parse into a tag" do
    mention = stub_mentions.first
    mention.text = " #ds10"
    tweet = Tweet.new(mention)
    assert_equal "ds10", tweet.hashtag
  end

  test "tweet without hashtag should have nil tag" do
    mention = stub_mentions.first
    mention.text = "no tag"
    tweet = Tweet.new(mention)
    assert_nil tweet.hashtag
  end

  test "tweet without hashtag should not save" do
    mention = stub_mentions.first
    mention.text = "no tag"

    assert_tweet_not_saved(mention)  
  end

  test "tweet with unrecognized hashtag should not save" do
    mention = stub_mentions.first
    mention.text = " #ds999"

    assert_tweet_not_saved(mention)  
  end

  test "tweet with no photo URL should not save" do
    mention = stub_mentions.first
    mention.text.gsub!('http', '')

    assert_tweet_not_saved(mention)  
  end
    
  test "saving a valid tweet should create a photo and photog" do
    mention = stub_mentions.first

    assert_difference "Photo.count" do
      assert_difference "Photog.count" do
        tweet = Tweet.new(mention)
        assert tweet.save
      end
    end
  end

protected

  def assert_tweet_not_saved(mention)
    tweet = Tweet.new(mention)
    assert_no_difference "Photo.count" do
      assert_no_difference "Photog.count" do
        tweet = Tweet.new(mention)
        assert !tweet.save
      end
    end
  end  
end
