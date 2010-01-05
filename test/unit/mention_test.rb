require 'test_helper'

class MentionTest < ActiveSupport::TestCase

  test "create with blank tweet_id should fail" do
    assert_no_difference "Mention.count" do
      mention = new_mention :tweet_id => ""
      assert !mention.valid?
    end
  end

  test "create with blank text should fail" do
    assert_no_difference "Mention.count" do
      mention = new_mention :text => ""
      assert !mention.valid?
    end
  end
  
  test "mention with hashtag should parse into a tag" do
    raw_mention = stub_mentions.first
    raw_mention.text = " #ds10"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert_equal "ds10", mention.tag
  end
  
  test "mention with capitalized hashtag should parse into a lowercase tag" do
    raw_mention = stub_mentions.first
    raw_mention.text = " #DS10"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert_equal "ds10", mention.tag
  end

  test "mention without hashtag should have nil tag" do
    raw_mention = stub_mentions.first
    raw_mention.text = "no tag"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert_nil mention.tag
  end

  test "mention without hashtag should have nil assignment" do
    raw_mention = stub_mentions.first
    raw_mention.text = "no tag"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert_nil mention.assignment
  end

  test "mention with hashtag should have assignment" do
    raw_mention = stub_mentions.first
    raw_mention.text = assignments(:ds10).tag
    mention = Mention.from_raw_mention(raw_mention)
    
    assert assignments(:ds10), mention.assignment
  end

  test "mention with unknown photog's screen_name should new photog record" do
    raw_mention = stub_mentions.first
    raw_mention.user.screen_name = "unknown"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert mention.photog.new_record?
  end

  test "mention with known photog's screen_name should have existing photog record" do
    raw_mention = stub_mentions.first
    raw_mention.user.screen_name = photogs(:joe).screen_name
    mention = Mention.from_raw_mention(raw_mention)
    
    assert_equal photogs(:joe), mention.photog
  end
  
  test "should have one pending mention" do
    pending_mentions = Mention.pending
    
    assert_equal 1, pending_mentions.size
    assert_equal mentions(:pending), pending_mentions.first
  end
  
  test "mention with RT should be a retweet" do
    raw_mention = stub_mentions.first
    raw_mention.text = "RT "
    mention = Mention.from_raw_mention(raw_mention)
    
    assert mention.retweet?
  end
  
  test "mention without RT should not be a retweet" do
    raw_mention = stub_mentions.first
    raw_mention.text = "retweeting"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert !mention.retweet?
  end
  
  test "mention with RT should not parse" do
    raw_mention = stub_mentions.first
    raw_mention.text = "#ds10 RT"
    mention = Mention.from_raw_mention(raw_mention)
    
    assert !mention.parse!
    assert_equal "Retweet: #ds10 RT", mention.parse_message
  end
  
protected

  def new_mention(options={})
    options = {
      :tweet_id => 123,
      :text => "Tweet, tweet!",
      :user_id => 123,
      :screen_name => "clarkware",
      :profile_image_url => "url"
    }.merge(options)

    Mention.create(options)
  end

end