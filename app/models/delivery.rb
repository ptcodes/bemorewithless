class Delivery < ActiveRecord::Base
  translates :name
  attr_accessible :name

  has_and_belongs_to_many :gifts

  validates :name, presence: true, uniqueness: true
end
