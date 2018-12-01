class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    quantity = params["quantity"]
    render json: MerchantSerializer.new(Merchant.with_most_items_sold(quantity))
  end
end
