class ProjectsController < ApplicationController
  load_and_authorize_resource :on => [:new, :edit, :destroy]

  def index
    @projects = Project.order(:id)
  end
end
