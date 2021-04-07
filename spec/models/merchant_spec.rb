require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "Relationships" do
    it { should have_many :items }
  end

  describe "scope" do
    describe ".paginate" do
      it "seperates into pages and limits merchant per page" do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)
        merchant_4 = create(:merchant)
        merchant_5 = create(:merchant)
        merchant_6 = create(:merchant)

        expected = [merchant_3, merchant_4]
        
        expect(Merchant.paginate(page: 2, per_page: 2)).to eq(expected)
      end
    end
  end

  describe "class methods" do
    describe ".find_merchant_by_name" do
      it "returns the first merchant for the given name regardless of capitalization" do
        merchant_1 = create(:merchant, name: "Ring World")

        expect(Merchant.find_merchant_by_name("ring")). to eq(merchant_1)
        expect(Merchant.find_merchant_by_name("rInG")). to eq(merchant_1)
      end

      it "returns the first merchant alphabetically for the given name" do
        turing = create(:merchant, name: "Turing")
        ring_world = create(:merchant, name: "Ring World")

        expect(Merchant.find_merchant_by_name("ring")). to eq(ring_world)        
        expect(Merchant.find_merchant_by_name("RinG")). to eq(ring_world)        
      end
    end
  end
end
