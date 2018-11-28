require 'rails_helper'
require './lib/modules/csv_adapter'

describe CSVAdapter do
  describe 'Class Methods' do
    describe '#import' do
      it 'passes new data with valid models and data-files' do
        described_class.import(models: [Merchant, Customer])
        expect(Merchant.first.name).to eq("Schroeder-Jerde")
        expect(Merchant.last.name).to eq("Wisozk, Hoeger and Bosco")
      end
      it 'does not duplicate or overwrite entries' do
        described_class.import(models: [Merchant, Customer])
        described_class.import(models: [Merchant, Customer])
        expect(Merchant.count).to eq(100)
      end
    end
    describe '#import_file' do
      it 'creates new entries for a single file' do
        described_class.import_file('./data/merchants.csv', Merchant)
        expect(Merchant.first.name).to eq("Schroeder-Jerde")
        expect(Merchant.last.name).to eq("Wisozk, Hoeger and Bosco")
      end
    end
  end
end
