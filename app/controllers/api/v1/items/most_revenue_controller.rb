class Api::V1::Items::MostRevenueController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.with_most_revenue(params[:quantity]))
  end
end
