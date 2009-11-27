class TweetCollector

  def initialize
    @count = 0
    @tweets = Tweets.new
  end

  def get_mentions(page)
    @tweets.mentions(:page => page)
  end
 
  def run
    create_sample_assignments # temporary
    
    page = 1
    last = Photo.first(:order => 'created_at desc')
    loop do
      mentions = get_mentions(page)
      page += 1
      break unless mentions.first
      found = false
      mentions.each do |mention|
        if last && mention[:id].to_i <= last.source_id
          found = true
          break
        end
        next unless Photo.all(:conditions => {:source_id => mention[:id].to_i}).count.zero?
        tweet = Tweet.new(mention)
        if tweet.save
          puts "#{@count}. #{tweet.photog.screen_name} #{tweet.assignment.tag}"
        else
          if tweet.hashtag && tweet.assignment.nil?
            puts "Could not find assignment: #{tweet.hashtag}"
          elsif tweet.photo.nil?
            puts "Could not parse tweet: #{mention.text}" 
          else
            puts "Unable to save photo: #{tweet.photo.inspect}"
          end
        end
        @count += 1
      end
      $stderr.puts "#{@count} mentions saved"
      @count = 0
      break if found
      sleep 1
    end
  end
    
  def create_sample_assignments
    Assignment.delete_all
    Assignment.create([
      {
        :date => Date.parse('2009/11/26'),
        :text => "It's Thanksgiving in the US. What are you thankful for? Make a photograph and share it with the world.",
        :tag => "ds11"
      },
      {
        :date => Date.parse('2009/11/25'),
        :text => "Let's play with movement today. Get a shot of something in motion. Freeze it or let it blur. It's up to you!",
        :tag => "ds10"
      },
      {
        :date => Date.parse('2009/11/24'),
        :text => "You might not be next to an ocean, but surely you can find some water around you to take a photo of.",
        :tag => "ds9"
      },
      {
        :date => Date.parse('2009/11/23'),
        :text => "How do ants see the world? Change your viewpoint. Make a photograph with your camera at floor level",
        :tag => "ds8"
      }
    ])  
    puts "Created #{Assignment.count} assignments."
  end
  
end
