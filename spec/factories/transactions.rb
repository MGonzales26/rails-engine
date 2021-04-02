FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { 1065406540 }
    result { "" }
  end
end
