module MentionsHelper
  
  def link_to_tweet(mention)
    link_to mention.screen_name, 
            "http://twitter.com/#{mention.screen_name}/status/#{mention.tweet_id}"
  end
  
end
