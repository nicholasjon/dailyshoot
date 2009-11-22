module WelcomeHelper
  
  def auto_link_user(screen_name)
    auto_link screen_name.gsub(/@(\w+)/, %Q{@<a href="http://twitter.com/\\1">\\1</a>})
  end
  
end
