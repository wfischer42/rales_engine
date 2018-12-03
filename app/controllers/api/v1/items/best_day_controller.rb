class Api::V1::Items::BestDayController < ApplicationController
  def show
    render json: serialize_date("best_day", Item.best_day(params[:id]))
  end
end
