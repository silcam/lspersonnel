# aka furlough, but not all of these will be furloughs
class Leave < ApplicationRecord

  belongs_to :person
  has_and_belongs_to_many :leave_reasons

  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :start_date_is_before_end_date

  def self.leave_type_hash(person)
    leave_hash = {
      future: [], next_year: [], this_year: [],
      soon: [], current: [], last: [], old: []
    }

    person.leaves.each do |lv|
      leave_hash[:old] << lv if lv.old?
      leave_hash[:soon] << lv if lv.soon?
      leave_hash[:current] << lv if (lv.current?)
      leave_hash[:this_year] << lv if (lv.this_year?)
      leave_hash[:next_year] << lv if (lv.next_year?)
      leave_hash[:future] << lv if (lv.future?)

      if (leave_hash[:last].size == 0)
        leave_hash[:last] << lv if lv.old?
      else
        if leave_hash[:last][0].end_date < lv.end_date
          leave_hash[:last][0] = lv if lv.old?
        end
      end
    end

    leave_hash
  end

  def old?
    end_date < Date.today
  end

  def future?
    start_date > Date.today
  end

  def soon?
    start_date < ( Date.today >> 3 )
  end

  def this_year?
    start_date >= Date.new(Date.today.year,1,1) &&
      start_date < Date.new(Date.today.year + 1,1,1)
  end

  def next_year?
    start_date >= Date.new(Date.today.year + 1,1,1) &&
      start_date < Date.new(Date.today.year + 2,1,1)
  end

  def current?
    start_date < Date.today && end_date > Date.today
  end

  def start_date_is_before_end_date
    return if (start_date.nil? || end_date.nil?)
    if (start_date >= end_date)
      errors.add(:start_date, "must be before end date")
      errors.add(:end_date, "must be after start_date")
    end
  end

end
