require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { is_expected.to have_many(:invoices) }
  it { is_expected.to have_many(:items) }
  it { is_expected.to have_many(:invoice_items).through(:invoices) }

  describe "Instance Methods" do
    describe ".revenue" do
      it "returns merchant's total revenue" do
        merchant = create(:merchant)
        # Only inventory items "1 and 2" appear on an invoice with a successful
        # transaction.
        inv_item_1 = create_list(:invoice_item_chain, 3, merchant: merchant)[0]
        inv_item_2 = create(:invoice_item, invoice: Invoice.first, merchant: merchant)
        create(:transaction, result: :success, invoice: Invoice.first)
        create(:transaction, result: :failed, invoice: Invoice.last)

        result = inv_item_1.revenue + inv_item_2.revenue
        expect(merchant.revenue).to eq(result)
      end
    end
  end

  describe "Class Methods" do
    describe "with_most_revenue" do
      it "returns the x merchants with the most revenue" do
        merchants = create_list(:merchant, 8)
        invoice_items = create_list(:invoice_item_chain, 20)
        9.times do
          create(:transaction, result: :success, invoice: Invoice.all.sample)
          create(:transaction, result: :failed, invoice: Invoice.all.sample)
        end

        expected = Merchant.all.sort_by do |merchant|
          merchant.revenue * -1
        end[0..2]

        actual = Merchant.with_most_revenue(3)
        expect(actual).to eq(expected)
      end
    end
  end
end
