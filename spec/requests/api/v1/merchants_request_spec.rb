require 'rails_helper'

describe "Merchants API" do
  describe "index endpoint" do
    it "returns all merchants" do
      merchs = create_list(:merchant, 5)
      get '/api/v1/merchants'
      parsed = JSON.parse(response.body)

      expect(response).to be_successful
      expect(parsed["data"][0]["id"].to_i).to eq(merchs[0].id)
      expect(parsed["data"][-1]["id"].to_i).to eq(merchs[-1].id)
    end
  end
  describe "show endpoint" do
    it "returns selected merchant" do
      merch = create(:merchant)
      get "/api/v1/merchants/#{merch.id}"
      parsed = JSON.parse(response.body)

      expect(response).to be_successful
      expect(parsed["data"]["id"].to_i).to eq(merch.id)
    end
  end
  describe "most_revenue endpoint" do
    it "returns x merchants with the highest revenue" do
      merchs = create_list(:merchant, 5)
      get '/api/v1/merchants/most_revenue?quantity=x'

      expect(response).to be_successful
    end
  end
end
