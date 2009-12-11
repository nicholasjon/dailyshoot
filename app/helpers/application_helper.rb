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
end
