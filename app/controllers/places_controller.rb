class PlacesController < ApplicationController
  before_filter :find_region

  def new
    @place = Place.new
  end

  def create
    place = @region.places.new(place_params)
    place.save
    place.crop_image
    redirect_to project_region_path(@region.project, @region)
  end

  def find_region
    @region = Region.find(params['region_id'])
  end

  def place_params
    params.require(:place).permit(:x, :y, :image,
                                  :crop_x, :crop_y, :crop_width, :crop_height)
  end
end
