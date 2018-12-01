require 'rails_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  describe 'GET index' do
    it 'should be successful' do
      get :index

      expect(response).to have_http_status(:success)
    end

    it 'should respond with JSON' do
      merchants = build_stubbed_list(:merchant, 2)
      allow(Merchant).to receive(:all).and_return(merchants)

      get :index
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed[0]["attributes"]).to include( {"id"   => merchants[0].id,
                                                   "name" => merchants[0].name})
      expect(parsed[1]["attributes"]).to include( {"id"   => merchants[1].id,
                                                   "name" => merchants[1].name})
    end
  end

  describe 'GET show' do
    let(:merchant) { create(:merchant) }

    it 'should be successful' do
      get :show, params: { id: merchant.id }

      expect(response).to have_http_status(:success)
    end

    it 'should respond with JSON' do
      get :show, params: { id: merchant.id }
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["attributes"]).to include( {"id"   => merchant.id,
                                                "name" => merchant.name})
    end
  end
end
