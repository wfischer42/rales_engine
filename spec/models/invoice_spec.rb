require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { is_expected.to have_many(:transactions) }
  it { is_expected.to have_many(:invoice_items) }
  it { is_expected.to have_many(:items).through(:invoice_items) }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:merchant) }
end
