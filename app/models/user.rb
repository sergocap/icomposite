class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, default_url: '/images/missing.png', :styles => { :small => "64x64^" }, :convert_options => { :small => "-gravity center -extent 64x64" }
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => 'Формат файла должен быть jpg/jpeg/png/gif. '
  validates_attachment_size :avatar, in: 0..100.kilobytes, :message => 'Размер файла должен быть менее 100 КБ. '
  has_many :places
  before_destroy :destroy_attachments

  def destroy_attachments
    avatar.destroy
  end
end
