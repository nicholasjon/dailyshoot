xml.rss :version => "2.0" do
  xml.channel do 
    xml.title "The Daily Shoot"
    xml.link 'http://twitter.com/dailyshoot'
    xml.description "Daily shooting assignments to inspire and motivate you to practice your photography, and share your results!"
    xml.language 'en'
    xml.pubDate @assignments.first.date.to_s(:rfc822)
    xml.lastBuildDate @assignments.first.date.to_s(:rfc822)    
    @assignments.each do |assignment|
      xml.item do
        xml.title "#{assignment.tweet_date}: #{assignment.tag}"
        xml.description assignment.text
        xml.pubDate assignment.date.to_s(:rfc822)
        xml.link assignment_url(assignment)
        #xml.guid({:isPermaLink => "false"}, assignment.permalink)
      end
    end
  end
end
