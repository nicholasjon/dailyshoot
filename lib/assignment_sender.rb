require 'twitter_api'

class AssignmentSender
  
  def perform
    assignment = Assignment.today

    if assignment.tweeted_at      
      Rails.logger.warn "Today's assignment w/id #{assignment.id} already tweeted, skipping"
    else

      # push assignment to Twitter
      twitter = TwitterAPI.new
      #twitter.tweet assignment.as_tweet
      puts "PRETEND"

      # do our record keeping
      assignment.tweeted_at = Time.now
      assignment.save!
    
      # notify
      Rails.logger.info "Sent today's assignment to Twitter"
    end
    
    # enqueue ourselves for tomorrow
    tom = Date.tomorrow
    time = DateTime.civil(tom.year, tom.month, tom.day, 16)
    
    Delayed::Job.enqueue(self, 0, time)
  end
end