class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.with_most_revenue(quantity)
    Item.select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
        .joins(invoice_items: :invoice)
        .joins(invoices: :transactions)
        .merge(Transaction.success)
        .group(:id)
        .order("revenue DESC")
        .limit(quantity)
  end

  def self.most_sold(quantity)
    Item.select("items.*, SUM(invoice_items.quantity) AS revenue")
        .joins(invoice_items: :invoice)
        .joins(invoices: :transactions)
        .merge(Transaction.success)
        .group(:id)
        .order("revenue DESC")
        .limit(quantity)
  end

  def self.best_day(item_id)
    invoice = Invoice.select("DATE_TRUNC('day', invoices.created_at) AS date, COUNT(invoices) AS sales")
                     .joins(:invoice_items)
                     .joins(:transactions)
                     .merge(Transaction.success)
                     .where(invoice_items: {item_id: item_id})
                     .group("DATE_TRUNC('day', invoices.created_at)")
                     .order("sales DESC, date DESC")
                     .limit(1)
                     .last
    return invoice.date if invoice
  end
end
