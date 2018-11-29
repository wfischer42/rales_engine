require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { is_expected.to have_many(:invoices)}
end
