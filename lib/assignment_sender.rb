require 'twitter_api'

class AssignmentSender
  
  def perform
    assignment = Assignment.today
    
    if ENV['RAILS_ENV'] == "development"

    end

    if assignment.tweeted_at      
      Rails.logger.warn "Today's assignment w/id #{assignment.id} already tweeted, skipping"
    else

      # push assignment to Twitter
      if ENV['RAILS_ENV'] == 'production'
        twitter = TwitterAPI.new
        twitter.tweet assignment.as_tweet
      else
        puts "We'll pretend today's assignment tweet went out right now"
      end

      # do our record keeping
      assignment.tweeted_at = Time.now
      assignment.save!
    
      # notify
      Rails.logger.info "Sent today's assignment to Twitter"
    end
    
    # enqueue ourselves for tomorrow
    tom = Date.tomorrow
    time = DateTime.civil(tom.year, tom.month, tom.day, 16)
    
    Rails.logger.info "Scheduling AssignmentSender for #{time}"
    Delayed::Job.enqueue(self, 0, time)
  end
end