class PeriodicDocument < ApplicationRecord

  belongs_to :person

  validates :submission_date, presence: true

end
