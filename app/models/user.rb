class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, default_url: '/images/missing.png'
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_many :places
  before_destroy :destroy_attachments

  def destroy_attachments
    avatar.destroy
  end
end
