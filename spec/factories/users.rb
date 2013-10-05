# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Smith'
    email 'example@example.org'
    username 'johnsmith'
  end
end
