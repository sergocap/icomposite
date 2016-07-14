class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @projects = Project.order(:id)
  end
end
