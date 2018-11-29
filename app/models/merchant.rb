class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  has_many :invoice_items, through: :invoices
end
