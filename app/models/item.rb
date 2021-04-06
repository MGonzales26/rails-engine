class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  scope :paginate, -> (page:, per_page: )  {
    page = (page || 1).to_i
    per_page = (per_page || 20).to_i
    limit(per_page).offset((page - 1) * per_page)
  }
end
