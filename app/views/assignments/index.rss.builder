xml.rss :version => "2.0" do
  xml.channel do 
    xml.title "The Daily Shoot"
    xml.link 'http://twitter.com/dailyshoot'
    xml.description "Daily shooting assignments to inspire and motivate you to practice your photography, and share your results!"
    xml.language 'en'
    xml.pubDate @assignments.first.rfc822_date
    xml.lastBuildDate @assignments.first.rfc822_date    
    @assignments.each do |assignment|
      xml.item do
        xml.title "#{assignment.tweet_date}: ##{assignment.tag}"
        xml.description assignment.text
        xml.pubDate assignment.rfc822_date
        xml.link assignment_url(assignment)
        xml.guid({:isPermaLink => "false"}, assignment[:id])
      end
    end
  end
end
