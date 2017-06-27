class Region < ApplicationRecord
  require 'csv_importer'

  has_many :languages

  def self.import_csv
    CSVImporter.import 'import/regions.csv', Region, {id: 'id', name: 'Province'}
  end
end
