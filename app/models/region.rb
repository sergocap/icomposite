class Region < ActiveRecord::Base
  belongs_to :project
  has_many :places
  has_attached_file :image, default_url: '/images/missing.png'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_attached_file :preview, default_url: '/images/missing.png'
  validates_attachment_content_type :preview, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
