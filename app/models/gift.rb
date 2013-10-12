# == Schema Information
#
# Table name: gifts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  category_id :integer
#  state       :string(255)
#

class Gift < ActiveRecord::Base
  acts_as_taggable
  paginates_per 15

  attr_accessor :status
  attr_accessible :description, :title, :user_id, :tag_list, :category_id, :photos_attributes, :status, :address_attributes, :delivery_ids
  attr_accessor :current_user

  belongs_to :user
  belongs_to :category, counter_cache: true
  has_one  :address, as: :addressable, dependent: :destroy
  has_many :gift_comments, class_name: 'Comment', dependent: :destroy, conditions: {type_id: 1}
  has_many :meeting_comments, class_name: 'Comment', dependent: :destroy, conditions: {type_id: 2}
  has_many :thank_comments, class_name: 'Comment', dependent: :destroy, conditions: {type_id: 3}
  has_many :wishers, class_name: 'Wish', dependent: :destroy
  has_many :promisees, class_name: 'Wish', conditions: {promised: true}
  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :deliveries

  accepts_nested_attributes_for :photos, reject_if: lambda {|p| p[:image].blank?}, allow_destroy: true
  accepts_nested_attributes_for :address

  delegate :full_address, to: :address
  delegate :short_address, to: :address

  validates :title, :description, :category_id, presence: true
  validate :has_deliveries?

  state_machine :state, initial: :active do
    event :promise do
      transition active: :promised
    end

    event :unpromise do
      transition promised: :active
    end

    event :give do
      transition promised: :given
    end

    event :ungive do
      transition given: :promised
    end
  end

  default_scope order('created_at DESC')
  scope :by_tag, lambda { |tag| includes(:user).tagged_with(tag) }
  scope :by_category, lambda { |category| includes(:user).joins(:category).where('categories.id = ?', category) }

  def to_param
    "#{id}-#{title.parameterize}"
  end
  alias_method :permalink, :to_param

  def to_s
    title
  end

  def preview
    photos.first
  end

  def can_be_wished?
    !given? && !new_record?
  end

  def can_be_wished_by?(user = nil)
    us = user ||= current_user
    !given? && !new_record? && !owner?(current_user) && !wished_by(current_user)
    # rest of your code
  end

  def promised_to_anyone?
    wishers.where(promised: true).count > 0
  end

  def wished_by(user)
    wishers.map(&:user).include?(user)
  end

  def owner?(user)
    self.user == user
  end

  def wishers_count
    wishers.count
  end

  def comments_count
    gift_comments.count + meeting_comments.count + thank_comments.count
  end

  private

  def has_deliveries?
    errors.add(:deliveries, "Gift must have some delivery methods") if self.deliveries.blank?
  end
end
