FactoryBot.define do
  factory :invoice_item do
    item 
    invoice 
    quantity { 10 }
    unit_price { 5.5 }
  end
end
