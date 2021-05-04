class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.revenue_by_date_range(start_date, end_date)
      joins(invoice: :transactions)
      .where('transactions.result = ?', 'success')
      .where('invoices.status = ?', 'shipped')
      .where('invoices.created_at between ? and ?', 
       Date.parse(start_date).beginning_of_day, 
       Date.parse(end_date).end_of_day)
      .revenue
  end

  def self.weekly_revenue
  end
  
end
