class TweetCollector

  def initialize
    @count = 0
    @tweets = Tweets.new
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
        save mention
      end
      $stderr.puts "#{@count} mentions saved"
      @count = 0
      break if found
      sleep 5
    end
  end
  
  def save(mention)
    photog = Photog.find_by_screen_name(mention.user.screen_name)
    unless photog
      photog = Photog.create(:screen_name => mention.user.screen_name, 
                             :name => mention.user.name)
    end
    if mention.text =~ /#(ds\d{1,3})/
      assignment = Assignment.find_by_tag($1)
      return unless assignment
      
      photo = Photo.from_tweet(mention.text)
      unless photo 
        puts "Could not parse tweet: #{mention.text}"
        return
      end
      
      photo.source_id = mention[:id].to_i
      photo.assignment = assignment
      photo.photog = photog
      photo.save
      puts "#{@count}. #{photog.screen_name} #{assignment.tag}"
      @count += 1
    end
  end
  
  def get_mentions(page)
    @tweets.mentions(:page => page)
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
