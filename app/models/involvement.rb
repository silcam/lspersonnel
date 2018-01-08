class Involvement < ActiveRecord::Base

  belongs_to :language
  belongs_to :person

  validates :level, presence: true
  validates :level, numericality: { only_integer: true }

end
