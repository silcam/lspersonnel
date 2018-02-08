class Language < ApplicationRecord
  require 'csv_importer'

  has_many :involvements
  has_many :people, through: :involvements
  has_many :quarterly_reports
  has_many :primary_reports
  has_many :research_permits

  has_and_belongs_to_many :departments

  def self.build_research_string(languages_ary)
    return nil if (languages_ary.nil? || languages_ary.size == 0)

    statement = ""
    if (languages_ary.size > 1)
      statement += "les langues "
      languages_ary.each.with_index do |i,index|
        statement += i.name.downcase
        statement += "," if (languages_ary.size > 2 && index < languages_ary.size - 1)
        statement += " et " if (index < languages_ary.size - 1)
      end
      statement += " parlées dans"
    else
      statement += "la langue #{languages_ary.pop.name.downcase} parlée dans"
    end
    statement
  end

  def self.import_csv
      CSVImporter.import 'import/languages.csv', Language, {id: 'id', name: 'Language', region_id: 'RegionID'}
  end

end
