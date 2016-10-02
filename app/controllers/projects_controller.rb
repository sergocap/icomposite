class ProjectsController < ApplicationController
  load_and_authorize_resource :on => [:new, :edit, :destroy]

  def index
    if params[:category].present?
      @projects = Project.by_category(params[:category])
    else
      @projects = Project.all
    end
    @projects = @projects.order(:id)
  end
end
