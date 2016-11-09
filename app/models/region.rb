class Region < ActiveRecord::Base
  attr_accessor :project_id_v, :count_x_v, :count_y_v
  belongs_to :project
  has_many :places
  has_many :place_original_images, dependent: :destroy
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :preview, default_url: '/images/missing.png', :styles => lambda { |a| { :medium => "#{a.instance.medium_width.ceil}x#{a.instance.medium_height.ceil}" } }
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
    preview.reprocess!
    project.generate_preview
  end

  def add_to_preview(place)
    pimg = Magick::Image.read(preview.path)[0]
    if place.image_width != project.size_place_x || place.image_height != project.size_place_y
      place.scaling_image
      place.update_size
    end
    place_img = Magick::Image.read(place.image.path)[0]
    pimg.composite!(place_img, project.size_place_x * place.x, project.size_place_y * place.y, Magick::OverCompositeOp)
    pimg.write(preview.path)
    preview.reprocess!
    project.add_to_preview(self)
  end

  def delete_from_preview(place)
    pimg = Magick::Image.read(preview.path)[0]
    place_original = place_original_images.where(:x => place.x, :y => place.y).first
    place_img = Magick::Image.read(place_original.image.path)[0]
    pimg.composite!(place_img, project.size_place_x * place.x, project.size_place_y * place.y, Magick::OverCompositeOp)
    pimg.write(preview.path)
    preview.reprocess!
    project.add_to_preview(self)
  end

  def medium_height
    prjct = self.persisted? ? project : Project.find(project_id_v)
    cnt_y = self.persisted? ? count_y : count_y_v
    cnt_y * prjct.size_place_y / prjct.resize_factor
  end

  def medium_width
    prjct = self.persisted? ? project : Project.find(project_id_v)
    cnt_x = self.persisted? ? count_x : count_x_v
    cnt_x * prjct.size_place_x / prjct.resize_factor
  end
end
