class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant_by_name(name)
    merchant = where('name ilike ?', "%#{name}%").order(:name).first
  end
end
