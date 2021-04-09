FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name  }
    description { "MyString" }
    unit_price { 5 }
    merchant { nil }
  end
end
