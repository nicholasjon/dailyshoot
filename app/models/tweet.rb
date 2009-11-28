class Tweet

  attr_reader :mention, :assignment, :photo, :photog
  
  def initialize(mention)
    @mention = mention
  end
 
  def hashtag
    @mention.text =~ /#(ds\d{1,3})/ ? $1 : nil
  end
  
  def save
    return false unless hashtag
    
    @assignment = Assignment.find_by_tag(hashtag)
    return false unless @assignment
    
    @photo = Photo.from_tweet(self.mention.text)
    return false unless @photo 
    
    @photog = Photog.for_twitter_user(self.mention.user)
          
    @photo.tweet_id = self.mention[:id].to_i
    @photo.assignment = @assignment
    @photo.photog = @photog
    @photo.save
  end  
end
