class PlacesController < ApplicationController
  load_and_authorize_resource :only => [:edit, :new, :update, :destroy]
  before_filter :find_region_and_project
  before_filter :find_place, only: [:edit, :update, :color_edit, :crop_edit, :destroy]
  before_filter :find_place_original_image, only: [:edit, :color_edit, :crop_edit]
  layout false, only: :show

  def new
    @place = current_user.places.new
    @place.x = params[:x]
    @place.y = params[:y]
    @place_original_image = @region.place_original_images.where(["x = ? and y = ?", params[:x], params[:y]]).first
    if @place_original_image.nil?
      @place_original_image = PlaceOriginalImage.create(region_id: @region.id, x: params[:x], y: params[:y])
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  def create
    @place = current_user.places.new(place_params)
    @place.region_id = @region.id
    @place.project_id = @region.project.id
    if @place.save
      @place.update_size
      @place.scaling_image_from_width(500)
      if editing_params?
        custom_redirect
      else
        add_to_preview_if_empty
        redirect_to project_region_path(@project, @region)
      end
    else
      redirect_to new_project_region_place_path(@project, @region, :x => @place.x, :y => @place.y)
    end
  end

  def add_to_preview_if_empty
    if Place.is_empty?(@region, @place.x, @place.y)
      @place.scaling_image
      @place.update_attribute(:state, :published)
      @region.add_to_preview(@place)
    end
  end

  def edit
    @place.update_size
    @place.update_attribute(:state, :draft)
    @region.delete_from_preview(@place)
  end

  def update
    @place.update_attributes(place_params)
    @place.scaling_image_from_width(500)

    if editing_params?
      custom_redirect
    else
      add_to_preview_if_empty
      redirect_to project_region_path(@project, @region)
    end
  end

  def destroy
    @place.destroy
    @region.delete_from_preview(@place)
    redirect_to project_region_path(@project.id, @region.id)
  end

  def custom_redirect
    if params[:crop_edit]
      redirect_to crop_edit_project_region_place_path(@project, @region, @place) and return
    end

    if params[:crop_color_edit]
      @place.update_attribute(:state, :crop_edit)
      redirect_to crop_edit_project_region_place_path(@project, @region, @place) and return
    end


    if params[:color_edit]
      @place.update_size
      redirect_to color_edit_project_region_place_path(@project, @region, @place) and return
    end

    if params[:cropped]
      @place.crop_image
      if @place.state == :crop_edit
        @place.update_attribute(:state, :color_edit)
        @place.update_size
        redirect_to color_edit_project_region_place_path(@project, @region, @place) and return
      else

      redirect_to edit_project_region_place_path(@project, @region, @place) and return
      end
    end

    if params[:colored]
      @place.svg_save
      redirect_to edit_project_region_place_path(@project, @region, @place) and return
    end
  end

  def editing_params?
    return false if %w(crop_edit crop_color_edit color_edit cropped colored) & params.to_a.flatten == []
    true
  end

  def find_region_and_project
    @region = Region.find(params['region_id'])
    @project = @region.project
  end

  def find_place
    @place = Place.find(params['id'])
  end

  def find_place_original_image
    @place_original_image = @region.place_original_images.where(["x = ? and y = ?", @place.x, @place.y]).first
  end

  def place_params
    params.require(:place).permit(:region_id, :x, :y, :image, :comment,
                                  :crop_x, :crop_y, :crop_width, :crop_height,
                                  :blur, :saturate, :r_component, :g_component, :b_component)
  end
end
