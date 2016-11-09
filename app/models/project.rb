class Project < ActiveRecord::Base
  has_many :regions, dependent: :destroy
  has_many :places, dependent: :destroy
  has_attached_file :image, default_url: '/images/missing.png'
  has_attached_file :preview, default_url: '/images/missing.png', :styles => {
                                                                  :on_manage      => "64x64^",
                                                                  :on_navigation  => "150x150^",
                                                                  :on_main        => "300x300^" },
                                                                  :convert_options => {
                                                                    :on_manage     => "-gravity center -extent 64x64"
                                                                  }
  validates_attachment_content_type :preview, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  before_destroy :destroy_attachments
  after_create :set_some_params

  extend Enumerize
  enumerize :category, in: ['Музыка', 'Фильмы', 'Интерьер', 'Природа', 'Животные', 'Абстракции', 'Люди', 'Города', 'Минимализм', 'Игры', 'Спорт', 'Наука', 'Техника', 'Другое']
  validates :category, presence: true

  scope :by_category, -> (c) { where(:category => c) }

  def Project.categories_list
    ['Музыка', 'Фильмы', 'Интерьер', 'Природа', 'Животные', 'Абстракции', 'Люди', 'Города', 'Минимализм', 'Игры', 'Спорт', 'Наука', 'Техника'].sort << 'Другое'
  end

  def destroy_attachments
    image.destroy
    preview.destroy
  end

  def total_places_count
    ((height / size_place_y) * (width / size_place_x)).to_i
  end

  def Project.categories
    pluck(:category).uniq.sort
  end

  def set_some_params
    update_attributes(:width => Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image)).width.to_i, :height => Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image)).height.to_i)
  end

  def generate_preview
    pimg = Magick::Image.read(image.path)[0]
    regions.each do |region|
      region_img = Magick::Image.read(region.preview.path)[0]
      pimg.composite!(region_img, region_width * region.x, region_height * region.y, Magick::OverCompositeOp)
    end
    file = Tempfile.new(['preview', '.png'])
    pimg.write(file.path)
    update_attribute(:preview, file)
    file.close
    file.unlink
    preview.reprocess!
  end

  def region_height
    standart_K * size_place_y
  end

  def region_width
    standart_K * size_place_x
  end

  def add_to_preview(region)
    pimg = Magick::Image.read(preview.path)[0]
    region_img = Magick::Image.read(region.preview.path)[0]
    pimg.composite!(region_img, region_width * region.x, region_height * region.y, Magick::OverCompositeOp)
    pimg.write(preview.path)
    preview.reprocess!
    to_complete if places.count == total_places_count
  end

  def to_complete!
    update_attribute(:state, 'complete')
  end

  def resize_factor
    width.to_f / 872.0
  end

  def to_development!
    update_attribute(:state, 'development')
  end

  def complete?
    return state == 'complete' ? true : false
  end

  def development?
    return state == 'development' ? true : false
  end

  def generate_regions
    img = edit_original
    (0...height).step(region_height).each_with_index do |y, index_y|
      (0...width).step(region_width).each_with_index do |x, index_x|
        img_region = img.crop(x, y, region_width, region_height, true)
        file = Tempfile.new(['region_preview', '.png'])
        img_region.write(file.path)
        regions.create(:image => file, :preview => file,
                       :x => index_x, :y => index_y, :project_id => id,
                       :count_x => img_region.columns/size_place_x,
                       :count_y => img_region.rows/size_place_y,
                       :height => img_region.rows,
                       :width => img_region.columns)
        file.close
        file.unlink
      end
    end
    generate_preview
  end

  def edit_original
    img = Magick::Image.read(image.path)[0]
    height = (img.rows/size_place_y).to_i * size_place_y
    width =  (img.columns/size_place_x).to_i * size_place_x
    img = img.crop(0, 0, width, height, true)
    img
  end
end
