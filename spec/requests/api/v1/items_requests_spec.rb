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

      it "returns the items with price at or below maximum parameter" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 10.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 8.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 5.00)
        item_4 = create(:item, merchant: merchant_1, unit_price: 3.00)

        get "/api/v1/items/find_all?max_price=8.00"
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data][0]).to be_a(Hash)
        expect(items[:data][0][:id].to_i).to eq(item_2.id)
        expect(items[:data][0]).to have_key(:attributes)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes][:unit_price]).to eq(item_2.unit_price)
        expect(items[:data][2]).to be_a(Hash)
        expect(items[:data][2][:id].to_i).to eq(item_4.id) 
        expect(items[:data][2]).to have_key(:attributes)
        expect(items[:data][2][:attributes]).to have_key(:unit_price)
        expect(items[:data][2][:attributes][:unit_price]).to eq(item_4.unit_price)
      end

      it "returns the items with price between both min and max parameter" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1, unit_price: 15.00)
        item_2 = create(:item, merchant: merchant_1, unit_price: 10.00)
        item_3 = create(:item, merchant: merchant_1, unit_price: 8.00)
        item_1 = create(:item, merchant: merchant_1, unit_price: 5.00)
        item_5 = create(:item, merchant: merchant_1, unit_price: 3.00)
        item_6 = create(:item, merchant: merchant_1, unit_price: 1.00)

        get "/api/v1/items/find_all?min_price=3.00&max_price=10.00"
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data][0]).to be_a(Hash)
        expect(items[:data][0][:id].to_i).to eq(item_2.id)
        expect(items[:data][0]).to have_key(:attributes)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes][:unit_price]).to eq(item_2.unit_price)
        expect(items[:data][3]).to be_a(Hash)
        expect(items[:data][3][:id].to_i).to eq(item_5.id) 
        expect(items[:data][3]).to have_key(:attributes)
        expect(items[:data][3][:attributes]).to have_key(:unit_price)
        expect(items[:data][3][:attributes][:unit_price]).to eq(item_5.unit_price)
      end
    end
  end

  describe "create item" do
    describe "happy path" do
      it "creates a new item" do
        merchant_1 = create(:merchant)
        #it needs a hash with name, description, unit_price, merchant_id
        params = {
                  :name => 'widget',
                  :description => 'does the thing',
                  :unit_price => 100.00,
                  :merchant_id => merchant_1.id
                  }
  
        post '/api/v1/items', params: { item: params }
        expect(response).to be_successful

        item = Item.last

        expect(item.name).to eq(params[:name])
        expect(item.description).to eq(params[:description])
        expect(item.unit_price).to eq(params[:unit_price])
        expect(item.merchant_id).to eq(params[:merchant_id])
      end
    end
  end

  describe "update item" do
    describe "happy path" do
      it "updates an existing item" do
        merchant_1 = create(:merchant)
        item = create(:item, name: 'widget', 
                             description: 'shiny',
                             unit_price: 5,
                             merchant: merchant_1)

        new_params = {name: 'a new widget', 
                      description: 'dull',
                      unit_price: 6}

        put "/api/v1/items/#{item.id}", params: { item: new_params }
        expect(response).to be_successful

        result = Item.find(item.id)

        expect(result.name).to eq('a new widget')
        expect(result.name).to_not eq('widget')
        expect(result.description).to eq('dull')
        expect(result.description).to_not eq('shiny')
        expect(result.unit_price).to eq(6)
        expect(result.unit_price).to_not eq(5)
      end
    end
  end

  describe "delete item" do
    describe "happy path" do
      it "deletes an item" do
        merchant_1 = create(:merchant)
        item = create(:item, merchant: merchant_1)

        expect(Item.count).to eq(1)

        delete "/api/v1/items/#{item.id}"
        expect(response).to be_successful

        expect(Item.count).to eq(0)
      end
    end
  end
end
