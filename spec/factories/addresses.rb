# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    country_code "MyString"
    state_code "MyString"
    city "MyString"
    addressable_id 1
    addressable_type "MyString"
  end
end
