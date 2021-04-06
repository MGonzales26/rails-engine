class ItemSerializer
  include FastJsonapi::ObjectSerializer
  # attributes :id


  attribute :name do |object|
    object.name
  end

  attribute :description do |object|
    object.description
  end

  attribute :unit_price do |object|
    object.unit_price
  end

  attribute :merchant_id do |object|
    object.merchant_id
  end
end
