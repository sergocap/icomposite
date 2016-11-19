class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout false, only: :close_message

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, nil, params[:project_id])
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def close_message
    current_user.update_attribute(:i_write, true)
    render nothing: true
  end

  def show_message
    current_user.update_attribute(:i_write, false)
    render nothing: true
  end
end
