require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "scope" do
    describe ".paginate" do
      it "seperates into pages and limits item per page" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_1)
        item_4 = create(:item, merchant: merchant_1)
        item_5 = create(:item, merchant: merchant_1)
        item_6 = create(:item, merchant: merchant_1)

        expected = [item_3, item_4]
        
        expect(Item.paginate(page: 2, per_page: 2)).to eq(expected)
      end
    end
  end

  describe "class methods" do
    describe ".items_within_price_range" do
      it "returns all of the items above the minimum threshold" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 10.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 8.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 5.00)
        item_4 = create(:item, merchant: merchant_1, unit_price: 3.00)

        expected = [item_1, item_2, item_3]

        expect(Item.items_within_price_range("5.00")).to eq(expected)
      end
    end
  end
end
