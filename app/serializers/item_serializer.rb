class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id

  set_type :item

  attribute :name do |object|
    object.name
  end
end
