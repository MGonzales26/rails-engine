class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes

  attribute :name do |object|
    object.name
  end
end
