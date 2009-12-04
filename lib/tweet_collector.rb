class TweetCollector

  attr_accessor :debug
  
  def initialize(twitter)
    @twitter = twitter
    @debug = false
    @count = 0
  end
  
  def run(max_pages=1000)
    page = 1
    
    last = Mention.first(:order => 'tweet_id desc')
    loop do
      @count = 0
      raw_mentions = @twitter.mentions(:page => page)
      break unless raw_mentions.first
      mention_exists = false
      raw_mentions.each do |raw_mention|
        if last && (raw_mention[:id].to_i <= last.tweet_id)
          mention_exists = true
          break
        end
        next if Mention.find_by_tweet_id(raw_mention[:id].to_i)
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

    unless mention.tag
      log "No hashtag: #{mention.text}"
      return false
    end
    
    assignment = mention.assignment
    unless assignment
      log "Unknown assignment tag: #{mention.tag}"
      return false
    end
    
    photos = mention.photos
    if photos.empty?
      log "Photo URL parse error: #{mention.text}" 
      return false
    end

    photog = mention.photog
    
    photos = photos.select do |photo| 
      Photo.find_by_url_and_photog_id(photo.url, photog.id).nil?
    end
    if photos.empty?
      log "Duplicate - skipping: #{mention.text}" 
      return false
    end
    
    if photog.new_record?
      photog.profile_image_url = mention.profile_image_url
      photog.save
    end

    photos.each do |photo|    
      photo.tweet_id = mention.tweet_id
      photo.tweeted_at = mention.tweeted_at
      photo.assignment = assignment
      photo.photog = photog
      photo.save
    end

    mention.was_parsed = true
    mention.save
    
  rescue => e
    log "Unable to collect mention: #{mention.text}: #{e.inspect}"
    return false
  end
   
private
  
  def log(message) 
    puts message if debug
  end
  
end