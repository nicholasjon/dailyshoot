module ApplicationHelper

  def photog_twitter_link(photog)
    link_to photog.screen_name, 'http://twitter.com/' + photog.screen_name
  end
  
  def labeled_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => LabeledFormBuilder)
    form_for(*(args + [options]), &block)
  end
  
end
