class Project < ActiveRecord::Base
  has_many :regions, dependent: :destroy
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :preview, default_url: '/images/missing.png'
  validates_attachment_content_type :preview, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  #def generate_places
    #img = Magick::Image.read(self.image.path)[0]
    #height = img.rows
    #width  = img.columns
    #(0...height).step(self.size_place_y).each_with_index do |y, index_y|
      #(0...width).step(self.size_place_x).each_with_index do |x, index_x|
        #img_place = img.crop(x, y, self.size_place_x, self.size_place_y)
        #file = Tempfile.new(['original_image', '.png'])
        #img_place.write(file.path)
        #self.places.create(:original_image => file, :x => index_x, :y => index_y)
        #file.close
        #file.unlink
      #end
    #end
  #end
  def generate_preview
    pimg = Magick::Image.read(image.path)[0]
    regions.each do |region|
      region_img = Magick::Image.read(region.preview.path)[0]
      pimg.composite!(region_img, region_width * region.x, region_height * region.y, Magick::OverCompositeOp)
    end
    file = Tempfile.new(['temp', '.png'])
    pimg.write(file.path)
    update_attribute(:preview, file)
    file.close
    file.unlink
  end

  def generate_regions
    img = edit_original
    height = img.rows
    width =  img.columns
    k = count_places_in_line_regions
    (0...height).step(self.size_place_y * k).each_with_index do |y, index_y|
      (0...width).step(self.size_place_x * k).each_with_index do |x, index_x|
        region_height = self.size_place_y * k;
        region_width = self.size_place_x * k;
        img_region = img.crop(x, y, region_width, region_height, true)
        file = Tempfile.new(['region_preview', '.png'])
        img_region.write(file.path)
        update_attribute(:region_height, region_height)
        update_attribute(:region_width, region_width)
        self.regions.create(:image => file, :preview => file,
                            :x => index_x, :y => index_y,
                            :count_x => img_region.columns/self.size_place_x,
                            :count_y => img_region.rows/self.size_place_y)
        file.close
        file.unlink
      end
    end
    generate_preview
  end

  def edit_original
    img = Magick::Image.read(self.image.path)[0]
    height = (img.rows/self.size_place_y).to_i * self.size_place_y
    width =  (img.columns/self.size_place_x).to_i * self.size_place_x
    img = img.crop(0, 0, width, height, true)

    #drw = Magick::Draw.new
    #drw.stroke_opacity(0.2)
    #(0..height).step(self.size_place_y).each do |i|
      #drw.line(0, i, width, i)
    #end
    #(0..width).step(self.size_place_x).each do |i|
      #drw.line(i, 0, i, height)
    #end
    #drw.draw(img)
    img
  end
end
