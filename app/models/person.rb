class Person < ApplicationRecord
  require 'csv_importer'

  has_many :involvements
  has_many :languages, through: :involvements
  has_many :leaves
  has_many :quarterly_reports
  has_many :primary_reports
  has_many :research_permits

  belongs_to :title
  belongs_to :nationality

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :gender, format: { with: /\A[M|F]{1}\z/ }

  def next_leave_start_date
    leaves.where("start_date > ?", Date.today).order("start_date").first&.start_date
  end

  def next_permit_expiration
    research_permits.where("expiry_date > now()").order("expiry_date").first&.expiry_date
  end

  # French adjective endings based on the person's gender.
  def adj_ending
    gender == 'M' ? "é" : "ée"
  end

  def salutation
    # TODO: Handle Mlle
    gender == 'M' ? "M." : "Mme."
  end

  def formal_name
    "#{formal_name_short} #{first_name.humanize}"
  end

  def formal_name_short
    "#{salutation} #{last_name.upcase}"
  end

  def filename
    "#{first_name.downcase}_#{last_name.downcase}"
  end

  def research_permit_number
    research_permits.select("identifier").
        where("issue_date < now() and expiry_date > now()").
            order("issue_date").limit(1).first&.identifier
  end

  # This is meant to be included in a renewal letter, something like "hey look at
  # my last letter sent on XX Mon YYYY, I deserve another permit".  For now, we'll
  # look at the latest submission date of a research permit and use that as the
  # last letter date until there is a better solution.
  def previous_letter_date
    research_permits.select("submission_date").
        where("submission_date < now()").
          order("submission_date DESC").limit(1).first&.submission_date
  end

  def request_period_for_letter
    if (/^[a|e|i|o|u|y]/ =~ request_period)
      "d'#{request_period}"
    else
      "de #{request_period}"
    end
  end

  def research_statement
    languages = {}
    departments = {}

    invs = involvements.select{ |i| i.level == InvolvementLevel::PRIMARY::id }
    return nil if invs.size == 0

    # TODO: There has to be a better way than this.
    invs.each do |inv|
      languages[inv.language.name] = inv.language
      inv.language.departments.each do |dep|
        departments[dep.name] = dep
      end
    end

    languages_string = Language.build_research_string(languages.values)
    departments_string = Department.build_research_string(departments.values)
    return nil if (languages_string.nil? || departments_string.nil?)

    statement = "sur #{languages_string} #{departments_string}"
  end

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
