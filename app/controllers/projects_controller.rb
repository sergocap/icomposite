class ProjectsController < ApplicationController
  load_and_authorize_resource except: :index
  layout false, only: :get_modal_resolve_size
  layout 'full_size', only: :show_complete_full_size

  def index
    @query = Project.search do
      fulltext params[:search]
      with :category, params[:category] if params[:category]
      with :state,    params[:state]    if params[:state] && params[:state] != 'all'
    end

    @projects = @query.results
  end

  def show
    redirect_to show_complete_project_path(@project.id) if @project.complete?
  end

  def get_modal_resolve_size
    render partial: 'projects/modal_resolve_size' and return
  end
end
