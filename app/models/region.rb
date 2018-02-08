class Region < ApplicationRecord
  require 'csv_importer'

  has_many :departments

  def self.import_csv
    CSVImporter.import 'import/regions.csv', Region, {id: 'id', name: 'Province'}
  end
end
