class TweetCollector

  attr_accessor :debug
  
  def initialize()
    @debug = false
    @count = 0
  end
  
  def run(max_pages=1000)
  	twitter = TwitterAPI.new
    page = 1
    
    last = Mention.first(:order => 'tweet_id desc')
    loop do
      @count = 0
      raw_mentions = twitter.mentions(:page => page)
      break unless raw_mentions.first
      mention_exists = false
      raw_mentions.each do |raw_mention|
        if last && (raw_mention[:id].to_i <= last.tweet_id.to_i)
          mention_exists = true
          break
        end
        next if Mention.find_by_tweet_id(raw_mention[:id].to_s)
        if collect(raw_mention)
          @count += 1
          log "#{@count}. #{raw_mention.user.screen_name} #{raw_mention.text}"
        end
      end
      log "#{@count} mentions saved"
      break if mention_exists
      break if page == max_pages
      page += 1
      sleep 1
    end
  end
  
  def collect(raw_mention)
    mention = Mention.from_raw_mention(raw_mention)
    unless mention.save
      log "Unable to save original mention: #{mention.inspect}"
      return false
    end

    unless mention.parse!
      log mention.parse_message
      return false
    end
    
    true
  end
  
  def perform
	run
    Delayed::Job.enqueue(self, 0, 10.minutes.from_now)  
  end
   
private
  
  def log(message) 
    puts message if debug
  end
  
end