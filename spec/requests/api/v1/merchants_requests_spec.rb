require 'rails_helper'

RSpec.describe "Merchants API" do
  it "gets all merchants" do
    create_list(:merchant, 50)

    get '/api/v1/merchants'

    expect(response).to be_success

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(50)
  end
end