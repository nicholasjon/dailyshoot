class TweetCollector

  def initialize
    @count = 0
    @tweets = Tweets.new
  end

  def get_mentions(page)
    @tweets.mentions(:page => page)
  end
 
  def run    
    page = 1
    last = Photo.first(:order => 'created_at desc')
    loop do
      mentions = get_mentions(page)
      page += 1
      break unless mentions.first
      found = false
      mentions.each do |mention|
        if last && mention[:id].to_i <= last.tweet_id
          found = true
          break
        end
        next unless Photo.all(:conditions => {:tweet_id => mention[:id].to_i}).count.zero?
        tweet = Tweet.new(mention)
        tweet.save
        puts "#{@count}. #{tweet.photog.screen_name} #{tweet.assignment.tag}"
        @count += 1
      end
      $stderr.puts "#{@count} mentions saved"
      @count = 0
      break if found
      sleep 1
    end
  end
  
end
