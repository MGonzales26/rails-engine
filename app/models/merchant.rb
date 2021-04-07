class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant_by_name(name)
    merchant = where('name ilike ?', "%#{name}%").first

  end
end
