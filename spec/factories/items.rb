FactoryBot.define do
  factory :item do
    merchant
    name { "MyString" }
    description { "MyText" }
    sequence :unit_price { |n| n }
  end
end
