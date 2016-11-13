class Place < ActiveRecord::Base
  belongs_to :region
  belongs_to :user
  belongs_to :project

  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width, :blur, :r_component, :g_component, :b_component
  has_attached_file :image, default_url: '/images/missing.png'
  has_attached_file :small_image, default_url: '/images/missing.png'

  extend Enumerize
  enumerize :state, in: [:new, :crop_edit, :color_edit, :draft, :published], :default => :new

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_presence :image
  validates_attachment_content_type :small_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_length_of :comment, :maximum => 60

  before_destroy :destroy_attachments

  scope :published, -> { where(:state => 'published') }
  scope :not_published, -> { where.not(:state => 'published') }

  def destroy_attachments
    image.destroy
    small_image.destroy
  end

  def Place.is_empty?(region, x, y)
    c = region.places.where(:x => x, :y => y, :state => :published).count
    return c == 0 ? true : false
  end

  def save_civil_image
    img = Magick::Image.read(image.path)[0]
    width_size = 100
    resize_f = FastImage.size(image.path)[0] * 1.0 / width_size
    height_size = (FastImage.size(image.path)[1] / resize_f).to_i
    img.resize!(width_size, height_size, Magick::LanczosFilter, 1.0)
    file = Tempfile.new(['img', '.png'])
    img.write(file.path)
    update_attribute(:image, file)
    update_attributes(:image_height => height_size, :image_width => width_size)
    file.close
    file.unlink
  end

  def save_small_image
    img = Magick::Image.read(image.path)[0]
    img.resize!(region.project.size_place_x, region.project.size_place_y, Magick::LanczosFilter, 1.0)
    file = Tempfile.new(['sm_img', '.png'])
    img.write(file.path)
    update_attribute(:small_image, file)
    file.close
    file.unlink
  end

  def scaling_image_from_width
    if FastImage.size(image.path)[0] > 500
      width_size = 500
      resize_f = FastImage.size(image.path)[0] * 1.0 / width_size
      height_size = (FastImage.size(image.path)[1] / resize_f).to_i
      img = Magick::Image.read(image.path)[0]
      img.resize!(width_size, height_size, Magick::LanczosFilter, 1.0)
      img.write(image.path)
    else
      width_size = FastImage.size(image.path)[0]
      height_size = FastImage.size(image.path)[1]
    end
    update_attributes(:image_height => height_size, :image_width => width_size)
  end

  def crop_image
    unless crop_height == '0' || crop_width == '0'
      img = Magick::Image.read(image.path)[0]
      img.crop!(crop_x.to_i, crop_y.to_i, crop_width.to_i, crop_height.to_i, true)
      img.write(image.path)
      update_attributes(:image_height => crop_height, :image_width => crop_width)
    end
  end

  def svg_image_save
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
                  </filter>
            </defs>
            <image filter='url(#fp1)' height='100%' width='100%' xlink:href='#{image.path}'></image>
          </svg>"
    file = File.new('svg_temp.svg', 'w+')
    File.write(file, svg_string)
    file_temp = Tempfile.new(['img', '.png'])

    system("inkscape -z -e #{file_temp.path}  #{file.path}")
    file.close
    File.delete(file)

    update_attribute(:image, file_temp)
    file_temp.close
    file_temp.unlink
  end
end
