class Place < ActiveRecord::Base
  belongs_to :project
  belongs_to :region
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :original_image, default_url: '/images/missing.png'
  validates_attachment_content_type :original_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
