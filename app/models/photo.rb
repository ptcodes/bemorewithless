# == Schema Information
#
# Table name: photos
#
#  id         :integer         not null, primary key
#  image      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  gift_id    :integer
#

class Photo < ActiveRecord::Base
  belongs_to :gift
  attr_accessible :image
  mount_uploader :image, ImageUploader
end
