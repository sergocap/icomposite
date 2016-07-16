class Manage::ProjectsController < Manage::ApplicationController
  load_and_authorize_resource except: [:create]
  before_filter :find_project, only: [:destroy, :show, :edit, :update]

  def new
    @project = Project.new
  end

  def index
    @projects = Project.order(:id)
  end

  def create
    project = Project.new project_params
    if project.save
      project.create_places
      redirect_to manage_projects_path
    else
      render :new
    end
  end

  def update
    if @project.update_attributes project_params
      redirect_to manage_projects_path
    else
      render :edit
    end
  end

  def destroy
    @project.delete
    redirect_to manage_projects_path
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :size_place_x, :size_place_y, :image)
  end
end
