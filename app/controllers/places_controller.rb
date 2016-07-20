class PlacesController < ApplicationController
  before_filter :find_region

  def new
    @place = Place.new
  end

  def create
    place = @region.places.new(place_params)
    place.save
    redirect_to project_region_path(@region.project, @region)
  end

  def find_region
    @region = Region.find(params['region_id'])
  end

  def place_params
    params.require(:place).permit(:x, :y, :image)
  end
end
