class Region < ActiveRecord::Base
  belongs_to :project
  has_many :places, dependent: :destroy
  has_many :place_original_images, dependent: :destroy
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :preview, default_url: '/images/missing.png'
  validates_attachment_content_type :preview, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  before_destroy :destroy_attachments

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
    project.generate_preview
  end
end
