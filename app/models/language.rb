class Language < ApplicationRecord
    require 'csv_importer'

    has_many :involvements
    has_many :people, through: :involvements
    has_many :quarterly_reports
    has_many :primary_reports
    has_many :research_permits

    belongs_to :region

    def self.import_csv
        CSVImporter.import 'import/languages.csv', Language, {id: 'id', name: 'Language', region_id: 'RegionID'}
    end
end 
