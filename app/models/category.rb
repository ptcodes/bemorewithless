# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  slug       :string(255)
#

class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  translates :name

  attr_accessible :name

  has_many :gifts

  validates :name, presence: true, uniqueness: true

  default_scope order('name ASC')

  def to_param
    slug
  end
end
