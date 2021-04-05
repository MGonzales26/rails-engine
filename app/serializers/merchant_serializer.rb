class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id
  set_type :merchant

  attribute :name do |object|
    object.name
  end
end
