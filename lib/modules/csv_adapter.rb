require 'csv'
require 'active_support/inflector'

module CSVAdapter
  def self.import(models:, path: './data/')
    models.each do |model|
      if model.class == Class && model.superclass == ApplicationRecord
        file = path + model.to_s.underscore.pluralize + '.csv'
        self.import_file(file, model)
      else
        puts "#{model} is not a valid model and will not be imported."
      end
    end
  end

  def self.import_file(file, model)
    entries = []
    CSV.foreach(file, headers: true) do |row|
      entries << model.new(row.to_h)
    end
    model.import(entries, on_duplicate_key_ignore: true)
  end
end
