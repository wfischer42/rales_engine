class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    quantity = params["quantity"]
    render json: MerchantSerializer.new(Merchant.with_most_revenue(quantity))
  end
end
