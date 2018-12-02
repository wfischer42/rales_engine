require 'rails_helper'

RSpec.describe Api::V1::Merchants::CustomersWithPendingInvoicesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end

    it 'responds with JSON' do
      customers = build_stubbed_list(:customer, 2)
      allow(Merchant).to receive(:customers_with_pending_invoices)
                         .with("1").and_return(customers)

      get :index, params: { id: 1 }
      parsed = JSON.parse(response.body)["data"]

      expected_1 = { "id" => customers[0].id,
                     "first_name" => customers[0].first_name,
                     "last_name" => customers[0].last_name }
      expected_2 = { "id" => customers[1].id,
                     "first_name" => customers[1].first_name,
                     "last_name" => customers[1].last_name }

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed[0]["attributes"]).to include(expected_1)
      expect(parsed[1]["attributes"]).to include(expected_2)
    end
  end

end
