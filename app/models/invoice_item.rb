class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.revenue_by_date_range(start_date, end_date)
    joins(invoice: :transactions)
    .where('result = ?', 'success')
    .where('transactions.created_at between ? and ?', Date.parse(start_date).beginning_of_day, Date.parse(end_date).end_of_day)
    .revenue
  end
  
  def self.revenue
    sum('quantity * invoice_items.unit_price')
  end
end
