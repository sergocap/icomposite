module ApplicationHelper
  def show_complete_project?
    return controller_action == 'projects_show' && Project.find(params[:id]).complete? ? true : false
  end

  def controller_action
    "#{controller_name}_#{action_name}"
  end
end
