class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  

  def revenue
    unit_price * quantity
  end
end
