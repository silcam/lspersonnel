class Director < ApplicationRecord

  validates :name, :title, presence: true

  def self.current_director
    Director.where("current = true")&.first
  end

end
