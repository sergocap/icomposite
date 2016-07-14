class Manage::ApplicationController < ApplicationController
  def current_ability
    @current_ability ||= Ability.new(current_user, params[:controller].split('/').first)
  end
end
