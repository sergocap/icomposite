class Project < ActiveRecord::Base
  has_many :regions, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :complete_project_storage
  has_many :users, through: :places
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
  scope :completed, -> { where(:state => 'complete') }
  scope :development, -> { where.not(:state => 'development') }

  extend Enumerize
  enumerize :category, in: ['Музыка', 'Фильмы', 'Интерьер', 'Природа', 'Животные', 'Абстракции', 'Люди', 'Города', 'Минимализм', 'Игры', 'Спорт', 'Наука', 'Техника', 'Другое']
  validates :category, presence: true

  scope :by_category, -> (c) { where(:category => c) }

  searchable do
    text :description, :title
    string :category
    string :state
  end

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

  def crop_civil_image
    img = Magick::Image.read(image.path)[0]
    h = (img.rows/size_place_y).to_i * size_place_y
    w =  (img.columns/size_place_x).to_i * size_place_x
    img = img.crop(0, 0, w, h, true)
    file = Tempfile.new([File.basename(image.path), '.jpg'])
    img.write(file.path)
    update_attribute(:image, file)
    update_attributes(:width => w, :height => h)
    image.reprocess!
    file.close
    file.unlink
  end

  def generate_preview
    pimg = Magick::Image.read(image.path)[0]
    regions.each do |region|
      region_img = Magick::Image.read(region.preview.path)[0]
      pimg.composite!(region_img, region_width * region.x, region_height * region.y, Magick::OverCompositeOp)
    end
    file = Tempfile.new(['preview', '.jpg'])
    pimg.write(file.path)
    update_attribute(:preview, file)
    preview.reprocess!
    file.close
    file.unlink
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

    to_complete! if places.count == total_places_count
  end

  def to_complete!
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    data_medium = view.render(
      partial: 'projects/complete_table_medium',
      layout: false,
      locals: { :project => self }
    )
    data_full_size = view.render(
      partial: 'projects/complete_table',
      layout: false,
      locals: { :project => self }
    )
    self.complete_project_storage.delete_all
    self.complete_project_storage.create(:data_medium => data_medium, :data_full_size => data_full_size)
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
    crop_civil_image
    img = Magick::Image.read(image.path)[0]
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
end
