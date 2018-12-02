require 'rails_helper'

RSpec.describe Item, type: :model do
  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to have_many(:invoice_items) }
  it { is_expected.to have_many(:invoices).through(:invoice_items) }

  # GET /api/v1/items/most_revenue?quantity=x returns the top x items ranked by total revenue generated
  describe "#with_most_revenue(quantity)" do
    it "returns the x items with the most revenue" do
      items = create_list(:item, 3)
      create(:invoice_item, item: items[0], quantity: 3, unit_price: 11,
                            trans_result: :success)
      create(:invoice_item, item: items[1], quantity: 13, unit_price: 1,
                            trans_result: :success)
      create(:invoice_item, item: items[2], quantity: 5, unit_price: 9,
                            trans_result: :success)

      top = Item.with_most_revenue(1)
      top_2 = Item.with_most_revenue(2)

      expect(top).to eq([items[2]])
      expect(top_2).to eq([items[2], items[0]])
    end
    it "doesn't include pending transactions" do
      items = create_list(:item, 3)
      create(:invoice_item, item: items[0], quantity: 10, unit_price: 10,
                            trans_result: nil)
      create(:invoice_item, item: items[1], quantity: 9, unit_price: 9,
                            trans_result: :failed)
      create(:invoice_item, item: items[2], quantity: 8, unit_price: 8,
                            trans_result: :success)

      top = Item.with_most_revenue(1)

      expect(top).to eq([items[2]])
    end
    it "returns all entries if request is greater" do
      create_list(:invoice_item, 3, trans_result: :success)

      top_4 = Item.with_most_revenue(4)

      expect(top_4.length).to eq(3)
    end
  end

  describe "#most_sold(quantity)" do
    it "returns the x items with the most units sold" do
      items = create_list(:item, 3)
      create(:invoice_item, item: items[0], quantity: 3,
                            trans_result: :success)
      create(:invoice_item, item: items[1], quantity: 13,
                            trans_result: :success)
      create(:invoice_item, item: items[2], quantity: 5,
                            trans_result: :success)

      top = Item.most_sold(1)
      top_2 = Item.most_sold(2)

      expect(top).to eq([items[1]])
      expect(top_2).to eq([items[1], items[2]])
    end
    it "doesn't include pending transactions" do
      items = create_list(:item, 3)
      create(:invoice_item, item: items[0], quantity: 9,
                            trans_result: nil)
      create(:invoice_item, item: items[1], quantity: 10,
                            trans_result: :failed)
      create(:invoice_item, item: items[2], quantity: 8,
                            trans_result: :success)

      top = Item.most_sold(1)

      expect(top).to eq([items[2]])
    end
    it "returns all entries if request is greater" do
      create_list(:invoice_item, 3, trans_result: :success)

      top_4 = Item.most_sold(4)

      expect(top_4.length).to eq(3)
    end
  end

  describe "#best_day(id)" do
    it "returns the day with the most sales for the item" do
      date_1 = "2018-02-05"
      date_2 = "2017-03-04"
      date_3 = "2016-04-03"
      time = " 12:00:00"
      item = create(:item)
      create_list(:invoice_item, 2, item: item, trans_result: :success,
                            created_at: date_1 + time)
      create_list(:invoice_item, 3, item: item, trans_result: :success,
                            created_at: date_2 + time)
      create_list(:invoice_item, 1, item: item, trans_result: :success,
                            created_at: date_3 + time)
      best_day = Item.best_day(item.id)

      expect(best_day).to eq(date_2)
    end
  end
end
