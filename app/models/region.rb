class Region < ActiveRecord::Base
  attr_accessor :project_id_v, :count_x_v, :count_y_v
  belongs_to :project
  has_many :places, dependent: :destroy
  has_many :place_original_images, dependent: :destroy
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :preview, default_url: '/images/missing.png', :styles => lambda { |a| { :medium => "#{a.instance.width/2}x#{a.instance.height/2}" } }
  validates_attachment_content_type :preview, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  before_destroy :destroy_attachments

  def initialize(args)
    @project_id_v = args[:project_id]
    @count_x_v = args[:count_x]
    @count_y_v = args[:count_y]
    super
  end

  def destroy_attachments
    image.destroy
    preview.destroy
  end

  def height
    if self.persisted?
      return count_y * project.size_place_y
    else
      return @count_y_v * Project.find(@project_id_v).size_place_y
    end

  end

  def width
    if self.persisted?
      return count_x * project.size_place_x
    else
      return @count_x_v * Project.find(@project_id_v).size_place_x
    end
  end

  def generate_preview
    pimg = Magick::Image.read(image.path)[0]
    places.where(:state => :published).each do |place|
      if place.image_width != project.size_place_x || place.image_height != project.size_place_y
        place.scaling_image
        place.update_size
      end
      place_img = Magick::Image.read(place.image.path)[0]
      pimg.composite!(place_img, project.size_place_x * place.x, project.size_place_y * place.y, Magick::OverCompositeOp)
    end
    file = Tempfile.new(['temp', '.png'])
    pimg.write(file.path)
    update_attribute(:preview, file)
    file.close
    file.unlink
    project.generate_preview
  end
end
