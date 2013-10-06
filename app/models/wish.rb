# == Schema Information
#
# Table name: wishes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  gift_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  promised   :boolean
#

class Wish < ActiveRecord::Base
  attr_accessible :gift_id, :user_id, :gift, :user, :promised

  belongs_to :gift
  belongs_to :user

  validate :gift_id, :user_id, presence: true
  validate :user_id, uniqueness: {scope: :gift_id}

  def promise!
    update_attribute(promised: true)
  end

end
