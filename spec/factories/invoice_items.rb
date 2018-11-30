FactoryBot.define do
  factory :invoice_item do

    transient { merchant { create(:merchant) } }

    item { create(:item, merchant: merchant) }
    invoice { create(:invoice, merchant: merchant) }

    quantity { 1 }
    unit_price { 1 }

    factory :invoice_item_chain do

      transient { merchant { Merchant.all.sample } }

      quantity { rand(1..10) }
      unit_price { rand(1..10) }

    end
  end
end
