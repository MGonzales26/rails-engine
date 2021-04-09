class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.items_within_price_range(min_price, max_price)
    where('unit_price between ? and ?', (min_price || 0) , (max_price || Float::INFINITY))
  end
end
