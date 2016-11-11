class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable
  has_attached_file :avatar, default_url: '/images/missing.png', :styles => { :small => "65x64^" }, :convert_options => { :small => "-gravity center -extent 64x64" }
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => 'Формат файла должен быть jpg/jpeg/png/gif. '
  has_many :places
  before_destroy :destroy_attachments

  def destroy_attachments
    avatar.destroy
  end

  def self.find_for_vkontakte_oauth access_token
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else
      user = User.new(:provider => access_token.provider, :url => access_token.info.urls.Vkontakte, :name => access_token.info.name)
      user.avatar = open(access_token.extra.raw_info.photo_200)
      user.save!(:validate => false)
      user
    end
  end
end
