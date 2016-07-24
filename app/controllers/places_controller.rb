class PlacesController < ApplicationController
  before_filter :find_region
  before_filter :find_place, only: [:edit, :update]

  def new
    @place = Place.new
  end

  def create
    place = @region.places.new(place_params)
    if place.save
      if params[:crop]
        redirect_to edit_project_region_place_path(@region.project, @region, place, place_params) and return
      end
    end
    redirect_to project_region_path(@region.project, @region)
  end

  def edit
  end

  def update
    @place.update_attributes(place_params)
    if params[:crop]
      redirect_to edit_project_region_place_path(@region.project, @region, @place, place_params) and return
    end
    #raise params.
    @place.crop_image
    redirect_to project_region_path(@region.project, @region)
  end

  def find_region
    @region = Region.find(params['region_id'])
  end

  def find_place
    @place = Place.find(params['id'])
  end

  def place_params
    params.require(:place).permit(:x, :y, :image,
                                  :crop_x, :crop_y, :crop_width, :crop_height)
  end
end
