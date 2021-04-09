class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :paginate, -> (page:, per_page: )  {
    page = ((page.to_i if (page.to_i >= 1)) || 1)
    per_page = (per_page || 20).to_i
    limit(per_page).offset((page - 1) * per_page)
  }

  def self.revenue
    sum('quantity * invoice_items.unit_price')
  end
end
