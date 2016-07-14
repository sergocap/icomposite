class Role < ActiveRecord::Base
  attr_accessible :role, :user_id
  belongs_to :user
  extend Enumerize
  enumerize :role, in: []
end
