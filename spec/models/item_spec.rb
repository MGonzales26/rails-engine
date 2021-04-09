require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
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

        expect(Item.items_within_price_range("5.00", nil)).to eq(expected)
      end

      it "returns all of the items below the maximum threshold" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 10.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 8.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 5.00)
        item_4 = create(:item, merchant: merchant_1, unit_price: 3.00)

        expected = [item_2, item_3, item_4]

        expect(Item.items_within_price_range(nil, "8.00")).to eq(expected)
      end

      it "returns all of the items between the minimum and maximum thresholds" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 10.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 8.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 5.00)
        item_4 = create(:item, merchant: merchant_1, unit_price: 3.00)

        expected = [item_2, item_3]

        expect(Item.items_within_price_range("5.00", "8.00")).to eq(expected)
      end

      it "can return any maximum item price" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 100000.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 80000.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 50000.00)
        item_4 = create(:item, merchant: merchant_1, unit_price: 30000.00)

        expected_1 = [item_1, item_2, item_3, item_4]
        expected_2 = [item_1, item_2, item_3]
        expected_3 = [item_1, item_2]
        expected_4 = [item_1]

        expect(Item.items_within_price_range("30000.00", nil)).to eq(expected_1)
        expect(Item.items_within_price_range("50000.00", nil)).to eq(expected_2)
        expect(Item.items_within_price_range("80000.00", nil)).to eq(expected_3)
        expect(Item.items_within_price_range("100000.00", nil)).to eq(expected_4)
      end
    end

    describe ".find_items_by_name" do
      it "returns an array of items matching the given name" do
        merchant_1 = create(:merchant)
        item_1 = create(:item,name: "Ring", merchant: merchant_1)
        item_2 = create(:item,name: "Turing Shirt", merchant: merchant_1)
  
        expected = [item_1, item_2]
        expect(Item.find_items_by_name("Ring")). to eq(expected)
      end
    end
  end
end
