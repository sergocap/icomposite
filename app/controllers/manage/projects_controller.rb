class Manage::ProjectsController < Manage::ApplicationController
  load_and_authorize_resource

  def create
    if @project.save
      @project.generate_regions
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
    @project.destroy
    redirect_to manage_projects_path
  end

  private

  def project_params
    params.require(:project).permit(:standart_K, :title, :description, :size_place_x, :size_place_y, :image, :category)
  end
end
