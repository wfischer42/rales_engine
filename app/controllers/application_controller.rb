class ApplicationController < ActionController::API
  def serialize_currency(label, amount)
    # Prices and revenues are handled as integers at the model level, so
    # part of serialization is converting cents to dollars
    {'data' => { 'attributes' => { label => (amount / 100.0).to_s } } }
  end
  def serialize_date(label, date)
    # Prices and revenues are handled as integers at the model level, so
    # part of serialization is converting cents to dollars
    {'data' => { 'attributes' => { label => date } } }
  end
end
