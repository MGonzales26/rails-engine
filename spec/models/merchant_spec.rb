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
end
