class Person < ApplicationRecord
  require 'csv_importer'

  has_many :involvements
  has_many :languages, through: :involvements
  has_many :leaves
  has_many :quarterly_reports
  has_many :primary_reports
  has_many :research_permits

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.all_cabtal
    where(cabtal: true)
  end

  def self.import_csv
    fields = {id: 'id',
        last_name: 'Surname', first_name: 'Forename', category: 'Category',
        job: 'Job', arrival: 'DateOfArrivalInBranch', departure: 'FinalDepartureDate',
        nationality: 'NationalityFrID', title: 'TitleID', gender: 'InterestID',
        language_id: 'MainLang'}
    CSVImporter.import('import/people.csv', Person, fields) do |params|
      params[:gender] = case params[:gender]
        when '1'
          'M'
        when '2'
          'F'
        when '3'
          'U'
      end

      params[:arrival] = CSVImporter.extract_date params[:arrival], 'dd/mm/yyyy'
      params[:departure] = CSVImporter.extract_date params[:departure], 'dd/mm/yyyy'
      params
    end
  end
end
