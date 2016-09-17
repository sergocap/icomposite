class PlacesController < ApplicationController
  before_filter :find_region
  before_filter :find_place, only: [:edit, :update, :color_edit, :crop_edit]
  before_filter :find_place_original_image, only: [:edit, :color_edit, :crop_edit]

  def new
    @place = Place.new
    @place_original_image = @region.place_original_images.where(["x = ? and y = ?", params[:x], params[:y]]).first
    if @place_original_image.nil?
      @place_original_image = PlaceOriginalImage.create(region_id: @region.id, x: params[:x], y: params[:y])
    end
  end

  def create
    @place = @region.places.new(place_params)

    if @place.save
      @place.update_size
      if editing_params?
        custom_redirect
      else
        redirect_to project_region_path(@region.project, @region)
      end
    else
      render :new
    end
  end

  def edit
    @place.update_size
  end

  def update
    @place.update_attributes(place_params)

    if editing_params?
      custom_redirect
    else
      @place.scaling_image
      redirect_to project_region_path(@region.project, @region)
    end
  end

  def custom_redirect
    if params[:crop_edit]
      redirect_to crop_edit_project_region_place_path(@region.project, @region, @place, place_params) and return
    end

    if params[:color_edit]
      redirect_to color_edit_project_region_place_path(@region.project, @region, @place, place_params) and return
    end

    if params[:cropped]
      @place.crop_image
      redirect_to edit_project_region_place_path(@region.project, @region, @place, place_params) and return
    end

    if params[:colored]
      @place.svg_save
      redirect_to edit_project_region_place_path(@region.project, @region, @place, place_params) and return
    end
  end

  def editing_params?
    return false if %w(crop_edit color_edit cropped colored) & params.to_a.flatten == []
    true
  end

  def find_region
    @region = Region.find(params['region_id'])
  end

  def find_place
    @place = Place.find(params['id'])
  end

  def find_place_original_image
    @place_original_image = @region.place_original_images.where(["x = ? and y = ?", @place.x, @place.y]).first
  end

  def place_params
    params.require(:place).permit(:x, :y, :image,
                                  :crop_x, :crop_y, :crop_width, :crop_height,
                                  :blur, :saturate, :r_component, :g_component, :b_component)
  end
end
