class Place < ActiveRecord::Base
  belongs_to :region
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :original_image, default_url: '/images/missing.png'
  validates_attachment_content_type :original_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def crop_image
    unless crop_x.blank?
      img = Magick::Image.read(self.image.path)[0]
      img.crop!(crop_x.to_i, crop_y.to_i, crop_width.to_i, crop_height.to_i, true)
      file = Tempfile.new(['image', '.png'])
      img.write(file.path)
      self.update_attribute(:image, file)
      file.close
      file.unlink
    end
  end
end
