module MobileHelper
  
  def assignment_summary(assignment)
    "#{assignment.position}. #{truncate(assignment.text, :length => 25)}"
  end
  
  def assignment_date(assignment)
    "#{Date::DAYNAMES[assignment.date.wday]}: #{assignment.tweet_date}"
  end
  
end
