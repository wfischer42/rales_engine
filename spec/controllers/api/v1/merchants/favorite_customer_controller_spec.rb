require 'rails_helper'

RSpec.describe Api::V1::Merchants::FavoriteCustomerController, type: :controller do
  describe 'GET show' do
    it 'returns HTTP success' do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end

    it 'responds with JSON' do
      customer = build_stubbed(:customer)
      allow(Merchant).to receive(:merchant_favorite_customer)
                         .with("1").and_return(customer)

      get :show, params: { id: 1 }
      parsed = JSON.parse(response.body)["data"]
      expected = { "id" => customer.id,
                   "first_name" => customer.first_name,
                   "last_name" => customer.last_name }

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["attributes"]).to include(expected)
    end
  end
end
