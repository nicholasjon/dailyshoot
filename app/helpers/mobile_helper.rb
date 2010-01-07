module MobileHelper
  
  def assignment_date(assignment)
    "#{Date::DAYNAMES[assignment.date.wday]}: #{assignment.tweet_date}"
  end
  
end
