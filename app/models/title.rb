class Title < ApplicationRecord

  has_many :people

  validates :title, presence: true

end
