require './lib/modules/csv_adapter'

namespace :csvmodel do
  desc "Import data from '/data/[FILENAME].csv' into the RalesEngine application database."

  task :import, [:model_names] => :environment do |task, args|
    model_names = args[:model_names].split
    models = model_names.inject([]) do |models, model_name|
      begin
        const = Object.const_get(model_name)
        models << const if const.class == Class &&
                           const.superclass == ApplicationRecord
      rescue
        puts "'#{model_name}' is not a valid model. Skipping..."
        models
      end
    end
    valid_models = models.map { |model| model.to_s }
    puts "Attempting database import from CSVs for models: [#{valid_models.join(', ')}] "
    CSVAdapter.import(models: models)
  end
end
