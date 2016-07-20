class Place < ActiveRecord::Base
  belongs_to :region
  attr_accessor :crop_x, :crop_y, :crop_height, :crop_width
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :original_image, default_url: '/images/missing.png'
  validates_attachment_content_type :original_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def update_attributes(att)

    scaled_img = Magick::ImageList.new(self.image.path)
    orig_img = Magick::ImageList.new(self.image.path(:original))
    scale = orig_img.columns.to_f / scaled_img.columns

    args = [ att[:crop_x], att[:crop_y], att[:crop_width], att[:crop_height]  ]
    args = args.collect { |a| a.to_i * scale  }

    orig_img.crop!(*args)
    orig_img.write(self.image.path(:original))

    self.image.reprocess!
    self.save

    super(att)
  end
end
