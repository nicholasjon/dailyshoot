require 'twitter_api'

class AssignmentSender
  
  def perform
    assignment = Assignment.today

    if assignment.tweeted_at      
      Rails.logger.warn "Today's assignment w/id #{assignment.id} already tweeted, skipping"
    else
     
      TwitterAPI.tweet_as_dailyshoot(assignment.as_tweet)
      
      # do our record keeping
      assignment.tweeted_at = Time.now
      assignment.save!
    
      # notify
      Rails.logger.info "Sent today's assignment to Twitter"
    end
    
    # enqueue ourselves for tomorrow. and use GMT time
    tom = Date.tomorrow
    time = DateTime.civil(tom.year, tom.month, tom.day, 14)
    
    Rails.logger.info "Scheduling AssignmentSender for #{time}"
    Delayed::Job.enqueue(self, 0, time)
  end
end

