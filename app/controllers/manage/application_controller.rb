class Manage::ApplicationController < ApplicationController
  def current_ability
    @current_ability ||= Ability.new(current_user, params[:controller].split('/').first)
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
end
