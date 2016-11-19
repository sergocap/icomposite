class PlacesController < ApplicationController
  load_and_authorize_resource
  before_filter :find_region_and_project
  before_filter :find_place_original_image, only: [:edit, :crop_edit, :color_edit]
  layout false, only: :show

  def new
    @place.x = params[:x]
    @place.y = params[:y]
    unless @place_original_image = @region.place_original_images.where(["x = ? and y = ?", params[:x], params[:y]]).first
      @place_original_image = @region.place_original_images.create(x: params[:x], y: params[:y])
    end
  end

  def create
    @place.user_id = current_user.id
    @place.project_id = @project.id
    @place.region_id = @region.id
    if @place.save
      @place.scaling_image_from_width
      @place.update_attribute(:state, :crop_edit)
      redirect_to crop_edit_project_region_place_path(@project, @region, @place) and return
    else
      redirect_to new_project_region_place_path(@project, @region, :x => @place.x, :y => @place.y) and return
    end
  end

  def edit
    @place.update_attribute(:state, :draft)
    @region.delete_from_preview(@place) if @place.state == 'published'
  end

  def update
    @place.update_attributes place_params
    if editing_params?
      custom_redirect
    else
      if Place.is_empty?(@region, @place.x, @place.y)
        @place.save_civil_image
        @place.save_small_image
        @region.add_to_preview(@place)
        @place.update_attribute(:state, :published)
      end
      redirect_to project_region_path(@project, @region)
    end
  end

  def destroy
    @region.delete_from_preview(@place) if @place.state == 'published'
    @place.destroy
    redirect_to project_region_path(@project.id, @region.id)
  end

  private

  def custom_redirect
    if params[:crop_edit]
      @place.scaling_image_from_width
      redirect_to crop_edit_project_region_place_path(@project, @region, @place) and return
    end

    if params[:crop_color_edit]
      @place.scaling_image_from_width
      @place.update_attribute(:state, :crop_edit)
      redirect_to crop_edit_project_region_place_path(@project, @region, @place) and return
    end

    if params[:color_edit]
      redirect_to color_edit_project_region_place_path(@project, @region, @place) and return
    end

    if params[:cropped]
      @place.crop_image
      if @place.state == :crop_edit
        @place.update_attribute(:state, :color_edit)
        redirect_to color_edit_project_region_place_path(@project, @region, @place) and return
      else
        redirect_to edit_project_region_place_path(@project, @region, @place) and return
      end
    end

    if params[:colored]
      @place.svg_image_save
      redirect_to edit_project_region_place_path(@project, @region, @place) and return
    end
  end

  def editing_params?
    return false if %w(crop_edit crop_color_edit color_edit cropped colored) & params.keys == []
    true
  end

  def find_region_and_project
    @region = Region.find(params['region_id'])
    @project = @region.project
  end

  def find_place_original_image
    @place = @region.places.find(params[:id])
    @place_original_image = @region.place_original_images.where('x = ? and y = ?', @place.x, @place.y).first
  end

  def place_params
    params.require(:place).permit(:x, :y, :image, :comment, :link,
                                  :crop_x, :crop_y, :crop_width, :crop_height,
                                  :blur, :saturate, :r_component, :g_component, :b_component)
  end
end
