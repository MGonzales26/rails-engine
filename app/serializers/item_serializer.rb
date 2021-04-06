class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id

  set_type :item

  attribute :name do |object|
    object.name
  end

  attribute :description do |object|
    object.description
  end

  attribute :unit_price do |object|
    object.unit_price
  end
end
