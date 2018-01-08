class Language < ActiveRecord::Base
    require 'csv_importer'

    has_many :involvements
    has_many :people, through: :involvements

    belongs_to :region

    def self.import_csv
        CSVImporter.import 'import/languages.csv', Language, {id: 'id', name: 'Language', region_id: 'RegionID'}
    end
end 
