class PlacesController < ApplicationController
  before_filter :find_region
  before_filter :find_place, only: [:edit, :update, :color_edit, :crop_edit]

  def new
    @place = Place.new
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
  end

  def update
    @place.update_attributes(place_params)
    @place.update_size

    if editing_params?
      custom_redirect
    else
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

  def place_params
    params.require(:place).permit(:x, :y, :image,
                                  :crop_x, :crop_y, :crop_width, :crop_height,
                                  :saturate, :r_component, :g_component, :b_component)
  end
end
