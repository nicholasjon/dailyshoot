module AssignmentsHelper
  
  def nav_link_separator
    %{<span class="separator"> | </span>}
  end
  
  def navigation_links(assignment)
    links = []
    unless @assignment.first?
      links << link_to("Previous", assignment_path(@assignment.position - 1))
    end
    links << link_to('All', assignments_path)
    unless @assignment.last?
      links << link_to("Next", assignment_path(@assignment.position + 1))
    end
    links.join(nav_link_separator)
  end
  
end
