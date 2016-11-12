module ApplicationHelper
  def show_full_complete_project?
    return controller_action == 'projects_show' && Project.find(params[:id]).complete? && params[:full_width] ? true : false
  end

  def controller_action
    "#{controller_name}_#{action_name}"
  end
end
