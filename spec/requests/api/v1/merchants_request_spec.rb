require 'rails_helper'

describe "Merchants API" do
  describe "Endpoints: " do
    describe "index" do
      it "returns all merchants" do
        merchs = create_list(:merchant, 5)
        get '/api/v1/merchants'
        parsed = JSON.parse(response.body)

        expect(response).to be_successful
        expect(parsed["data"][0]["id"].to_i).to eq(merchs[0].id)
        expect(parsed["data"][-1]["id"].to_i).to eq(merchs[-1].id)
      end
    end

    describe "show" do
      it "returns selected merchant" do
        merch = create(:merchant)
        get "/api/v1/merchants/#{merch.id}"
        parsed = JSON.parse(response.body)

        expect(response).to be_successful
        expect(parsed["data"]["id"].to_i).to eq(merch.id)
      end
    end

    describe "most_revenue" do
      it "returns x merchants with the highest revenue" do
        merchants = create_list(:merchant, 8)
        invoice_items = create_list(:invoice_item_chain, 20)
        9.times do
          create(:transaction, result: :success, invoice: Invoice.all.sample)
          create(:transaction, result: :failed, invoice: Invoice.all.sample)
        end

        expected = Merchant.all.sort_by do |merchant|
          merchant.revenue * -1
        end[0..2]

        expected.map! { |merchant| merchant.id }

        get '/api/v1/merchants/most_revenue?quantity=3'
        parsed = JSON.parse(response.body)
        actual = parsed["data"].map { |merchant| merchant["id"].to_i }

        expect(response).to be_successful
        expect(actual).to eq(expected)
      end
    end
  end
end
