# This file is an example of what not to do! So don't do it

# require 'rails_helper'
#
# describe "Merchants API" do
#   describe "Endpoints: " do
#     describe "index" do
#       it "returns all merchants" do
#         merchs = create_list(:merchant, 5)
#         get '/api/v1/merchants'
#         parsed = JSON.parse(response.body)
#
#         expect(response).to be_successful
#         expect(parsed["data"][0]["id"].to_i).to eq(merchs[0].id)
#         expect(parsed["data"][-1]["id"].to_i).to eq(merchs[-1].id)
#       end
#     end
#
#     describe "show" do
#       it "returns selected merchant" do
#         merch = create(:merchant)
#         get "/api/v1/merchants/#{merch.id}"
#         parsed = JSON.parse(response.body)
#
#         expect(response).to be_successful
#         expect(parsed["data"]["id"].to_i).to eq(merch.id)
#       end
#     end
#
#     # describe "buisness intelligence" do
#     #   before do
#     #     merchants = create_list(:merchant, 10)
#     #     invoice_items = create_list(:invoice_item_chain, 15)
#     #     7.times do
#     #       create(:transaction, result: :success, invoice: Invoice.all.sample)
#     #       create(:transaction, result: :failed, invoice: Invoice.all.sample)
#     #     end
#     #   end
#     #
#     #   describe "most_revenue" do
#     #     it "returns x merchants with the highest revenue" do
#     #       # Stub these out
#     #       expected = Merchant.all.sort_by do |merchant|
#     #         [merchant.revenue * -1, merchant.id]
#     #       end[0..2]
#     #
#     #       expected.map! { |merchant| merchant.id }
#     #
#     #       get '/api/v1/merchants/most_revenue?quantity=3'
#     #       parsed = JSON.parse(response.body)
#     #       actual = parsed["data"].map { |merchant| merchant["id"].to_i }
#     #
#     #       expect(response).to be_successful
#     #       expect(actual).to eq(expected)
#     #     end
#     #   end
#
#       # describe "most_items" do
#       #   it "returns x merchants ranked by total number of items sold" do
#       #     expected = Merchant.all.sort_by do |merchant|
#       #       [merchant.items_sold * -1, merchant.id]
#       #     end[0..2]
#       #
#       #     expected.map! { |merchant| merchant.id }
#       #
#       #     get '/api/v1/merchants/most_items?quantity=3'
#       #     parsed = JSON.parse(response.body)
#       #     actual = parsed["data"].map { |merchant| merchant["id"].to_i }
#       #
#       #     expect(response).to be_successful
#       #     expect(actual).to eq(expected)
#       #   end
#       # end
#
#       # describe "revenue" do
#       #   it "returns total revenue by all merchants on x date" do
#       #     sum = Merchant.all.sum { |merchant| merchant.revenue}
#       #     expected = sum/100.0
#       #
#       #     get '/api/v1/merchants/revenue?date=2018-11-30'
#       #     parsed = JSON.parse(response.body)
#       #     actual = parsed["data"]["revenue"]
#       #     expect(response).to be_successful
#       #     expect(actual).to eq(expected)
#       #   end
#       # end
#     end
#   end
# end
