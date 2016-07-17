class Project < ActiveRecord::Base
  has_many :places
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def create_places
    img = Magick::Image.read(self.image.path)[0]
    height = img.rows
    width  = img.columns
    (0...height).step(self.size_place_y).each_with_index do |y, index_y|
      (0...width).step(self.size_place_x).each_with_index do |x, index_x|
        img_place = img.crop(x, y, self.size_place_x, self.size_place_y)
        file = Tempfile.new(['original_image', '.png'])
        img_place.write(file.path)
        self.places.create(:original_image => file, :x => index_x, :y => index_y)
        file.close
        file.unlink
      end
    end
  end


end
