require 'twitter_api'

class AssignmentSender
  
  def initialize(mode=:send)
    @mode = mode
  end
  
  def perform
    case @mode
    when :send
      send_todays_assignment
    when :reminder
      remind_todays_assignment
    else
      Rails.logger.warn "WhiskeyTangoFoxtrot: unknown AssignmentSender mode #{@mode}"
    end
  end
  
  def send_todays_assignment
    assignment = Assignment.today
    if assignment.tweeted_at      
      Rails.logger.warn "Today's assignment w/id #{assignment.id} already tweeted"
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
    
    # enqueue reminder for 10 hours from now
    Delayed::Job.enqueue(AssignmentSender.new(:reminder), 0, 10.seconds.from_now)
  end
  
  def remind_todays_assignment
    assignment = Assignment.today
    msg = "\##{assignment.tag} #{assignment.text} "
    TwitterAPI.tweet_as_dailyshoot(msg)
  end
end

