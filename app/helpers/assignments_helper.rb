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
    links.join(nav_link_separator)
  end
  
end
