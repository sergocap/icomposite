class Place < ActiveRecord::Base
  belongs_to :region
  belongs_to :user
  belongs_to :project
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width, :blur, :r_component, :g_component, :b_component
  has_attached_file :image, default_url: '/images/missing.png'
  has_attached_file :big_image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_presence :image
  validates_attachment_content_type :big_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
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

  def save_big_image
    if FastImage.size(image.path)[0] > 100
      img = Magick::Image.read(image.path)[0]
      img.resize!(100, (FastImage.size(image.path)[1] / (FastImage.size(image.path)[0] * 1.0 / 100)).to_i, Magick::LanczosFilter, 1.0)
      file = Tempfile.new(['bg_img', '.png'])
      img.write(file.path)
      update_attribute(:big_image, file)
      file.close
      file.unlink
    else
      self.big_image = self.image
      self.save
    end
  end

  def image_from_big_image
    if big_image.present? && state == :published
      self.image = self.big_image
      self.save
    end
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
    file_temp = Tempfile.new(['temp', '.png'])

    system("inkscape -z -e #{file_temp.path}  #{file.path}")

    file.close
    File.delete(file)

    update_attribute(:image, file_temp)
    file_temp.close
    file_temp.unlink
  end
end
