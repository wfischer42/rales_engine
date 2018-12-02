require 'rails_helper'

RSpec.describe Api::V1::Customers::FavoriteMerchantsController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end

    it 'responds with JSON' do
      merchant = build_stubbed(:merchant)
      allow(Customer).to receive(:favorite_merchant)
                         .with("1").and_return(merchant)

      get :show, params: { id: 1 }
      parsed = JSON.parse(response.body)["data"]
      expected = { "id"   => merchant.id,
                   "name" => merchant.name }

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["attributes"]).to include(expected)
    end
  end
end
