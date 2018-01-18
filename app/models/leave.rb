# aka furlough, but not all of these will be furloughs
class Leave < ActiveRecord::Base

  belongs_to :person
  has_and_belongs_to_many :leave_reasons

  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :start_date_is_before_end_date

  def start_date_is_before_end_date
    return if (start_date.nil? || end_date.nil?)
    if (start_date >= end_date)
      errors.add(:start_date, "must be before end date")
      errors.add(:end_date, "must be after start_date")
    end
  end

end
