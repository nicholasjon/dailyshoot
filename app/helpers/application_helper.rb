module ApplicationHelper

  def page_title(subtitle='')
    default = "| #{subtitle}" unless subtitle.blank?
    full_subtitle = @page_title ? "| #{@page_title}" : subtitle
    @page_title = "The Daily Shoot #{full_subtitle}"
  end
  
  def labeled_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => LabeledFormBuilder)
    form_for(*(args + [options]), &block)
  end

  def custom_javascript_includes
    @javascripts ||= []
    @javascripts.map { |s| javascript_include_tag(s) }.join("\n")
  end

  def add_javascript(name)
    @javascripts ||= []
    @javascripts << name
  end  
  
  def hover_menu_class(caption)
    (admin? && caption == 'assignment') ? 'hover-menu' : ''		
  end
  
  def new_window_link(link, text)
    "<a href=\"#{link}\" onclick=\"window.open(this.href);return false;\" rel=\"nofollow\">#{text}</a>"
  end
  
  def photo_thumb(photo)
    thumb_image = image_tag(photo.thumb_url, 
                            :alt => "", :width => 75, :height => 75)
    
    if photo.medium_url.nil? || !photo.supports_slideshow
      link_to(thumb_image, photo.url, 
              :title => "", :class => "", :rel => "nofollow", :popup => true)
	  else	
	    twitter_link = new_window_link("http://twitter.com/#{photo.photog_screen_name}", "@#{photo.photog_screen_name}")    
	    original_link = new_window_link(photo.url, photo.service_name)    
	    title = html_escape("Photo by #{twitter_link} &bull; View original on #{original_link}")
	    
	    link_to(thumb_image, photo.medium_url, 
          		:class => "zoom", :rel => "group", :title => title)
    end
	end
	
end
