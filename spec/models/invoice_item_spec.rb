require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "Relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "class methods" do
    describe ".revenue_by_date_range" do
      it "returns the total revanue of the system for the given date range" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        invoice_1 = create(:invoice, merchant: merchant_1)
        invoice_2 = create(:invoice, merchant: merchant_1)
        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success', created_at: '2021-04-07')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success', created_at: '2020-04-07')

        invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 10, created_at: '2021-04-07', item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:invoice_item, quantity: 1, unit_price: 5, created_at: '2020-04-07', item: item_1, invoice: invoice_2)
        
        start_date = '2021-04-01'
        end_date = '2021-04-08'

        expect(InvoiceItem.revenue_by_date_range(start_date, end_date)).to eq(10)
        expect(InvoiceItem.revenue_by_date_range(start_date, end_date)).to_not eq(15)
        expect(InvoiceItem.revenue_by_date_range(start_date, end_date)).to_not eq(5)
      end
    end
  end
end
