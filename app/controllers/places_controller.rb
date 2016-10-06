class PlacesController < ApplicationController
  load_and_authorize_resource :only => [:edit, :new, :update, :destroy]
  before_filter :find_region
  before_filter :find_place, only: [:edit, :update, :color_edit, :crop_edit, :destroy]
  before_filter :find_place_original_image, only: [:edit, :color_edit, :crop_edit]


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
    if @place.save
      @place.update_size
      if editing_params?
        custom_redirect
      else
        generate_preview_if_empty
        redirect_to project_region_path(@region.project, @region)
      end
    else
      redirect_to new_project_region_place_path(@region.project, @region, :x => @place.x, :y => @place.y)
    end
  end

  def generate_preview_if_empty
    if Place.is_empty?(@region, @place.x, @place.y)
      @place.update_attribute(:state, :published)
      @region.generate_preview
    end
  end

  def edit
    @place.update_size
    @place.update_attribute(:state, :draft)
    @region.generate_preview
  end

  def update
    @place.update_attributes(place_params)

    if editing_params?
      custom_redirect
    else
      generate_preview_if_empty
      redirect_to project_region_path(@region.project, @region)
    end
  end

  def destroy
    @place.destroy
    @region.generate_preview
    redirect_to project_region_path(@region.project.id, @region.id)
  end

  def custom_redirect
    if params[:crop_edit]
      if @place.state == :new
        @place.update_attribute(:state, :crop_edit)
      end
      redirect_to crop_edit_project_region_place_path(@region.project, @region, @place) and return
    end

    if params[:color_edit]
      @place.update_size
      redirect_to color_edit_project_region_place_path(@region.project, @region, @place) and return
    end

    if params[:cropped]
      @place.crop_image
      if @place.state == :crop_edit
        @place.update_attribute(:state, :color_edit)
        @place.update_size
        redirect_to color_edit_project_region_place_path(@region.project, @region, @place) and return
      else

      redirect_to edit_project_region_place_path(@region.project, @region, @place) and return
      end
    end

    if params[:colored]
      @place.svg_save
      redirect_to edit_project_region_place_path(@region.project, @region, @place) and return
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
    params.require(:place).permit(:region_id, :x, :y, :image,
                                  :crop_x, :crop_y, :crop_width, :crop_height,
                                  :blur, :saturate, :r_component, :g_component, :b_component)
  end
end
