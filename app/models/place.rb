class Place < ActiveRecord::Base
  belongs_to :region
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width, :blur, :saturate, :r_component, :g_component, :b_component
  validates :image, presence: true
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def scaling_image
    img = Magick::Image.read(image.path)[0]
    img.resize!(region.project.size_place_x, region.project.size_place_y, Magick::LanczosFilter, 1.0)
    file = Tempfile.new(['image', '.png'])
    img.write(file.path)
    update_attribute(:image, file)
    file.close
    file.unlink
  end

  def crop_image
    unless crop_x.blank?
      img = Magick::Image.read(image.path)[0]
      img.crop!(crop_x.to_i, crop_y.to_i, crop_width.to_i, crop_height.to_i, true)
      file = Tempfile.new(['image', '.png'])
      img.write(file.path)
      update_attribute(:image, file)
      file.close
      file.unlink
    end
  end

  def update_size
    update_column(:image_width,  Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image)).width.to_i)
    update_column(:image_height, Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image)).height.to_i)
  end

  def svg_save
    svg_string = "
          <svg height='#{image_height}' width='#{image_width}'>
            <defs>
                  <filter id='fp1'>
                    <feComponentTransfer>
                      <feFuncR slope='#{r_component}' type='linear'></feFuncR>
                      <feFuncG slope='#{g_component}' type='linear'></feFuncG>
                      <feFuncB slope='#{b_component}' type='linear'></feFuncB>
                      <feFuncA type='identity'></feFuncA>
                    </feComponentTransfer>
                    <feColorMatrix type='saturate' values='#{saturate}'></feColorMatrix>
                    <feGaussianBlur stdDeviation='#{blur}'></feColorMatrix>
                  </filter>
            </defs>
            <image filter='url(#fp1)' height='100%' width='100%' xlink:href='#{image.path}'></image>
          </svg>"
    file = File.new('svg_temp.svg', 'w+')
    File.write(file, svg_string)
    system("inkscape -z -e #{image.path}  #{file.path}")
    file.close
    File.delete(file)
  end
end
