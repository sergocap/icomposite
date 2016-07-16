class Project < ActiveRecord::Base
  has_many :places
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def create_places
    img = Magick::Image.read(self.image.path)[0]
    img = img.scale(134, 300)
    img.write 'rree.png'

  end


end
