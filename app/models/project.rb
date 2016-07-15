class Project < ActiveRecord::Base
  belongs_to :admin, class_name: 'User', foreign_key: 'user_id'
  has_many :places
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
