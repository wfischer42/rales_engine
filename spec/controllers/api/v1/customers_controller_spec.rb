require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'responds with JSON' do
      customers = build_stubbed_list(:customer, 2)
      allow(Customer).to receive(:all).and_return(customers)

      get :index
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed[0]["attributes"]).to include( {"id"   => customers[0].id,
                                                   "first_name" => customers[0].first_name})
      expect(parsed[1]["attributes"]).to include( {"id"   => customers[1].id,
                                                   "first_name" => customers[1].first_name})
    end
  end

  describe "GET #show" do
    let(:customer) { create(:customer) }
    it "returns http success" do
      get :show, params: { id: customer.id }
      expect(response).to have_http_status(:success)
    end
    it 'responds with JSON' do
      get :show, params: { id: customer.id }
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["attributes"]).to include( {"id"   => customer.id,
                                                "first_name" => customer.first_name})
    end
  end

end
