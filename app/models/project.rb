class Project < ActiveRecord::Base
  has_many :regions, dependent: :destroy
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :preview, default_url: '/images/missing.png', :styles => {
                                                                  :on_manage      => "64x64^",
                                                                  :on_navigation  => "150x150^",
                                                                  :on_main        => "300x300^" },
                                                                  :convert_options => {
                                                                    :on_manage     => "-gravity center -extent 64x64"
                                                                  }
  validates_attachment_content_type :preview, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  before_destroy :destroy_attachments
  extend Enumerize
  enumerize :category, in: ['Музыка', 'Фильмы', 'Интерьер', 'Природа', 'Животные', 'Абстракции', 'Люди', 'Города', 'Минимализм', 'Игры', 'Спорт', 'Наука', 'Техника', 'Другое']
  validates :category, presence: true

  scope :by_category, -> (c) { where(:category => c) }

  def destroy_attachments
    image.destroy
    preview.destroy
  end

  def Project.categories
    pluck(:category).uniq
  end

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
    (0...height).step(size_place_y * k).each_with_index do |y, index_y|
      (0...width).step(size_place_x * k).each_with_index do |x, index_x|
        region_height = size_place_y * k;
        region_width = size_place_x * k;
        img_region = img.crop(x, y, region_width, region_height, true)
        file = Tempfile.new(['region_preview', '.png'])
        img_region.write(file.path)
        update_attribute(:region_height, region_height)
        update_attribute(:region_width, region_width)
        regions.create(:image => file, :preview => file,
                       :x => index_x, :y => index_y, :project_id => id,
                       :count_x => img_region.columns/size_place_x,
                       :count_y => img_region.rows/size_place_y)
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
