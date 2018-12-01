require 'rails_helper'

RSpec.describe Api::V1::Merchants::MostRevenueController, type: :controller do
  describe 'GET index' do
    it 'should be successful' do
      get :index, params: { quantity: 1 }

      expect(response).to have_http_status(:success)
    end

    it 'should respond with JSON' do
      merchants = build_stubbed_list(:merchant, 2)
      allow(Merchant).to receive(:with_most_revenue)
                         .with("2").and_return(merchants)

      get :index, params: { quantity: 2 }
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed[0]["attributes"]).to include( {"id"   => merchants[0].id,
                                                   "name" => merchants[0].name})
      expect(parsed[1]["attributes"]).to include( {"id"   => merchants[1].id,
                                                   "name" => merchants[1].name})
    end
  end
end
