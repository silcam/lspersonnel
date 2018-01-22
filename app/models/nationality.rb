class Nationality < ApplicationRecord

  has_many :people

  validates :nationality, presence: true

end
