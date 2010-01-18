namespace :photos do

  def update_image_urls(photos)
    photos.each do |photo|
      if photo.medium_url.nil?
        puts photo.url
        photo.update_image_urls
        photo.save
        puts photo.thumb_url
        puts photo.medium_url
        puts "\n"
      end
    end
  end
  
  desc "Fetches the thumb and medium URLs for all photos"
  task :fetch_all => :environment do
    update_image_urls(Photo.all)
  end
  
  desc "Fetches the thumb and medium URLs for all Flickr photos"
  task :fetch_flickr => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%flic%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all SmugMug photos"
  task :fetch_smugmug => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%smug%"])
    update_image_urls(photos)
  end

  desc "Fetches the thumb and medium URLs for all TwitPic photos"
  task :fetch_twitpic => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%twitpic%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all BestCam photos"
  task :fetch_bestcam => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%best%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all TweetPhoto photos"
  task :fetch_tweetphoto => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%tweetphoto%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all yFrog photos"
  task :fetch_yfrog => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%yfrog%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all imgur photos"
  task :fetch_imgur => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%imgur%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all SnapTweet photos"
  task :fetch_snaptweet => :environment do
    photos = Photo.all(:conditions => ["url like ?", "%snaptweet%"])
    update_image_urls(photos)
  end
  
  desc "Fetches the thumb and medium URLs for all yFrog photos"
  task :missing => :environment do
    Photo.all.each { |p| puts p.url if p.medium_url.nil? }
  end
  
end