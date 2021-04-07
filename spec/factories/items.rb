FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name  }
    description { "MyString" }
    merchant { nil }
  end
end
