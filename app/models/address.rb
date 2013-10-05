# == Schema Information
#
# Table name: addresses
#
#  id               :integer         not null, primary key
#  country_code     :string(255)
#  state_code       :string(255)
#  city             :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :country_code, :city, presence: true, on: :update

  attr_accessible :addressable_id, :addressable_type, :city, :country_code, :state_code

  def country
     Carmen::Country.coded(country_code).name if country_code.present?
  end

  def full_address
    [country, state_code, city].compact.reject(&:blank?).join(', ')
  end

  def short_address
    [city, country].compact.reject(&:blank?).join(', ')
  end

  def to_s
    full_address
  end

end
