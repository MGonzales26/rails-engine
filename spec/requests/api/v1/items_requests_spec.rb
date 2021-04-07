require 'rails_helper'

RSpec.describe "Items API" do
  describe "all Items" do
    describe "happy path" do
      it "gets all items limited to 20 unless optional query params passed" do
        merchant_1 = create(:merchant)
        create_list(:item, 50, merchant: merchant_1)
    
        get '/api/v1/items'
        expect(response).to be_success
    
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(20)
    
        get '/api/v1/items?per_page=45'
        expect(response).to be_success
    
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(45)
      end
    
      it "gets all items limited to 20 unless optional query params passed including page numbers" do
        merchant_1 = create(:merchant)
    
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_1)
        item_4 = create(:item, merchant: merchant_1)
        item_5 = create(:item, merchant: merchant_1)
        item_6 = create(:item, merchant: merchant_1)
        item_7 = create(:item, merchant: merchant_1)
        item_8 = create(:item, merchant: merchant_1)
        item_9 = create(:item, merchant: merchant_1)
        item_10 = create(:item, merchant: merchant_1)
    
        get '/api/v1/items?per_page=8'
    
        expect(response).to be_success
    
        items = JSON.parse(response.body, symbolize_names: true)

        # expect(items).to have_key([:data])
        expect(items[:data].count).to eq(8)
    
        get '/api/v1/items?per_page=5&page=2'
    
        expect(response).to be_success
    
        items = JSON.parse(response.body, symbolize_names: true)
    
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data][0]).to have_key(:id)
        expect(items[:data][0][:id].to_i).to eq(item_6.id)
        expect(items[:data][0]).to have_key(:type)
        expect(items[:data][0][:type]).to eq("item")
        expect(items[:data][0]).to have_key(:attributes)
        expect(items[:data][0][:attributes][:name]).to eq(item_6.name)
        expect(items[:data][4][:id].to_i).to eq(item_10.id)
      end
    end

    describe "sad path" do
      it 'returns an empty array if there is no item' do
        get '/api/v1/items'
    
        expect(response).to be_success
    
        items = JSON.parse(response.body, symbolize_names: true)
        
        expected = []
        
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data]).to eq(expected)
      end
    end
  end

  describe "One item" do
    describe "happy path" do
      it "returns one item given an id" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
  
        get "/api/v1/items/#{item_1.id}"
  
        expect(response).to be_success
    
        item = JSON.parse(response.body, symbolize_names: true)
  
        expect(item).to be_a(Hash)
        expect(item).to have_key(:data)
        expect(item.count).to eq(1)
        expect(item[:data]).to be_a(Hash)
        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id].to_i).to eq(item_1.id)
        expect(item[:data]).to have_key(:type)
        expect(item[:data][:type]).to eq('item')
        expect(item[:data]).to have_key(:attributes)
        expect(item[:data][:attributes]).to be_a(Hash)
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to eq(item_1.name)
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to eq(item_1.description)
        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to eq(item_1.unit_price)
      end
    end
  end

  describe "items merchant" do
    describe "happy path" do
      it "the merchant for the item given" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)

        get "/api/v1/items/#{item_1.id}/merchant"
        expect(response).to be_success

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_a(Hash)
        expect(items[:data]).to have_key(:id)
        expect(items[:data][:id].to_i).to eq(merchant_1.id)
        expect(items[:data]).to have_key(:type)
        expect(items[:data][:type]).to eq('merchant')
        expect(items[:data]).to have_key(:attributes)
        expect(items[:data][:attributes]).to be_a(Hash)
        expect(items[:data][:attributes]).to have_key(:name)
        expect(items[:data][:attributes][:name]).to eq(merchant_1.name)
      end
    end
  end

  describe "item price range" do
    describe "happy path" do
      it "returns the items with price at or above minimum parameter" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 10.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 8.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 5.00)
        item_4 = create(:item, merchant: merchant_1, unit_price: 3.00)

        get "/api/v1/items/find_all?min_price=5.00"
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data][0]).to be_a(Hash)
        expect(items[:data][0][:id].to_i).to eq(item_1.id)
        expect(items[:data][0]).to have_key(:attributes)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes][:unit_price]).to eq(item_1.unit_price)
        expect(items[:data][2]).to be_a(Hash)
        expect(items[:data][2][:id].to_i).to eq(item_3.id) 
        expect(items[:data][2]).to have_key(:attributes)
        expect(items[:data][2][:attributes]).to have_key(:unit_price)
        expect(items[:data][2][:attributes][:unit_price]).to eq(item_3.unit_price)
      end
    end
  end
end
