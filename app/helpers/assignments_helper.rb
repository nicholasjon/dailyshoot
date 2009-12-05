module AssignmentsHelper
  
  def nav_link_separator
    %{<span class="separator"> | </span>}
  end
  
  def navigation_links(assignment)
    links = []
    unless @assignment.first?
      links << link_to("&larr; Previous Assignment", assignment_path(@assignment.position - 1))
    end
    links << link_to('All Assignments', assignments_path)
    if !@assignment.last? && @assignment.lower_item.published?
      links << link_to("Next Assignment &rarr;", assignment_path(@assignment.position + 1))
    end
    
    # Ha, yes. Messy.
    
    "<div class=\"assignment-nav\"><span class=\"previous\">#{links[0]}</span> <span class=\"all\">#{links[1]}</span> <span class=\"next\">#{links[2]}</span></div>"
  end
  
end
