class Person < ApplicationRecord
  require 'csv_importer'

  belongs_to :language

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