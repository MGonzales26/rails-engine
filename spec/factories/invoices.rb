FactoryBot.define do
  factory :invoice do
    customer 
    merchant { nil }
    status { "" }
  end
end
