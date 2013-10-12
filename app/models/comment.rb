# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  gift_id    :integer
#  type_id    :integer
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id, :gift_id, :gift, :type_id

  belongs_to :user
  belongs_to :gift

  validates :content, :user, :gift, presence: true

  scope :thanks, includes(:user, :gift).where(type_id: 3).order('created_at DESC').limit(5)

  default_scope order('created_at DESC')

  def gift_comment?
    type_id == 1
  end

  def meeting_comment?
    type_id == 2
  end

  def thank_comment?
    type_id == 3
  end

  def affected_users(commeners = true, wishers = false)
    users = []
    # gift's owner
    users << self.gift.user
    if commeners
      self.gift.gift_comments.each do |comment|
        users << comment.user
      end
    end
    if wishers
      self.gift.wishers.each do |wisher|
        users << wisher.user
      end
    end
    # delete user who left the comment
    users.uniq.reject{|user| user == self.user}
  end

  def owner?(user)
    self.user == user
  end

end
