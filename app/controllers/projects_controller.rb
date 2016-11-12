class ProjectsController < ApplicationController
  load_and_authorize_resource :on => [:new, :edit, :destroy]
  layout false, only: :get_modal_resolve_size
  layout 'full_size', only: :show_complete_full_size

  def index
    if params[:category].present?
      @projects = Project.by_category(params[:category])
    else
      @projects = Project.all
    end
    @projects = @projects.order(:id)
  end

  def show
    redirect_to show_complete_project_path(@project.id) if @project.complete?
  end

  def get_modal_resolve_size
    render partial: 'projects/modal_resolve_size' and return
  end
end
