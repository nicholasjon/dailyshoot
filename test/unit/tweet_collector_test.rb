require 'test_helper'

class TweetCollectorTest < ActiveSupport::TestCase
  
  test "mention without hashtag should not save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.text = "no tag"

    assert_byproducts_not_saved(raw_mention)  
  end

  test "mention with unrecognized hashtag should not save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.text = "#ds999"

    assert_byproducts_not_saved(raw_mention)  
  end

  test "mention with no photo URL should not save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.text.gsub!('http', '')

    assert_byproducts_not_saved(raw_mention)  
  end
    
  test "mention with one photo URL should save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.text = "##{assignments(:ds10).tag} http://bestc.am/oGuf"

    collector = TweetCollector.new(TwitterAPI.new)

    assert_difference "Mention.count" do
      assert_difference "Photo.count" do
        assert_difference "Photog.count" do
          assert collector.collect(raw_mention)
        end
      end
    end
  end

  test "mention with two photo URLs should save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.text = "##{assignments(:ds10).tag} http://bestc.am/oGuf http://twitpic.com/qosz0"

    collector = TweetCollector.new(TwitterAPI.new)
    
    assert_difference "Mention.count" do
      assert_difference "Photo.count", 2 do
        assert_difference "Photog.count" do
          assert collector.collect(raw_mention)
        end
      end
    end
  end

  test "mention with duplicate photo URL should not save byproducts" do
    photo = Photo.create(:url => "http://bestc.am/oGuf", 
                         :thumb_url => "http://bestc.am/oGuf",
                         :screen_name => "clarkware")
    raw_mention = stub_mentions.first
    raw_mention.text = "##{assignments(:ds10).tag} http://bestc.am/oGuf"

    collector = TweetCollector.new(TwitterAPI.new)
        
    assert_difference "Mention.count" do
      assert_no_difference "Photo.count" do
        assert_no_difference "Photog.count" do
          assert !collector.collect(raw_mention)
        end
      end
    end
  end

  test "mention with unknown photog's screen_name should save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.user.screen_name = "unknown"

    collector = TweetCollector.new(TwitterAPI.new)
        
    assert_difference "Mention.count" do
      assert_difference "Photo.count" do
        assert_difference "Photog.count" do
          assert collector.collect(raw_mention)
        end
      end
    end
  end

  test "mention with known photog's screen_name should save byproducts" do
    raw_mention = stub_mentions.first
    raw_mention.user.screen_name = photogs(:joe).screen_name

    collector = TweetCollector.new(TwitterAPI.new)
        
    assert_difference "Mention.count" do
      assert_difference "Photo.count" do
        assert_no_difference "Photog.count" do
          assert collector.collect(raw_mention)
        end
      end
    end
  end

protected

  def assert_byproducts_not_saved(raw_mention)
    collector = TweetCollector.new(TwitterAPI.new)
    assert_difference "Mention.count" do
      assert_no_difference "Photo.count" do
        assert_no_difference "Photog.count" do
          assert !collector.collect(raw_mention)
        end
      end
    end
  end  

end
