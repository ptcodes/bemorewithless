# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift do
    title "MyString"
    description "MyString"
    user_id 1
  end
end
