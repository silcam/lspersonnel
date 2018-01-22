class Director < ApplicationRecord

  validates :name, :title, presence: true

end
