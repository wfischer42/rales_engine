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
      it 'does not accept invalid models' do
        class NotAModel; end
        invalid = NotAModel
        expect { described_class.import(models: [invalid]) }
          .to output("#{invalid} is not a valid model and will not be imported.\n").to_stdout

        # Teardown so "NotAModel" doesn't exist, in case of testing elsewhere
        Object.send(:remove_const, :NotAModel)
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
