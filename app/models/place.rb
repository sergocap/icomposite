class Place < ActiveRecord::Base
  belongs_to :region
  belongs_to :user
  belongs_to :project
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width, :blur, :saturate, :r_component, :g_component, :b_component
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_presence :image
  validates_length_of :comment, :maximum => 60
  before_destroy :destroy_attachments
  extend Enumerize
  enumerize :state, in: [:new, :crop_edit, :color_edit, :draft, :published], :default => :new

  scope :published, -> { where(:state => 'published') }
  scope :not_published, -> { where.not(:state => 'published') }

  def destroy_attachments
    image.destroy
  end

  def Place.is_empty?(region, x, y)
    c = region.places.where(:x => x, :y => y, :state => :published).count
    return c == 0 ? true : false
  end

  def scaling_image
    if FastImage.size(image.path)[0] != project.size_place_x || FastImage.size(image.path)[1] != project.size_place_y
      img = Magick::Image.read(image.path)[0]
      img.resize!(region.project.size_place_x, region.project.size_place_y, Magick::LanczosFilter, 1.0)
      img.write(image.path)
    end
  end

  def scaling_image_from_width(width_size)
    if FastImage.size(image.path)[0] > width_size
      img = Magick::Image.read(image.path)[0]
      resize_f = FastImage.size(image.path)[0] * 1.0 / width_size
      img.resize!(width_size, (FastImage.size(image.path)[1] / resize_f).to_i, Magick::LanczosFilter, 1.0)
      img.write(image.path)
    end
  end

  def crop_image
    unless crop_height == '0' || crop_width == '0'
      img = Magick::Image.read(image.path)[0]
      img.crop!(crop_x.to_i, crop_y.to_i, crop_width.to_i, crop_height.to_i, true)
      img.write(image.path)
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
                    <feColorMatrix id='filter_saturate' type='saturate' values='#{saturate}'></feColorMatrix>
                    <feComponentTransfer>
                      <feFuncR slope='#{r_component}' type='linear'></feFuncR>
                      <feFuncG slope='#{g_component}' type='linear'></feFuncG>
                      <feFuncB slope='#{b_component}' type='linear'></feFuncB>
                      <feFuncA type='identity'></feFuncA>
                    </feComponentTransfer>
                  </filter>
            </defs>
            <image filter='url(#fp1)' height='100%' width='100%' xlink:href='#{image.path}'></image>
          </svg>"
    file = File.new('svg_temp.svg', 'w+')
    File.write(file, svg_string)

    system("inkscape -z -e #{image.path}  #{file.path}")

    path = image.path
    new_file_name = '1' + File.basename(path)
    FileUtils.move(path, File.join(File.dirname(path), new_file_name))
    self.image_file_name = new_file_name
    self.save

    file.close
    File.delete(file)
  end
end
