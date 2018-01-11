class Quarter

  attr_reader :quarter, :year

  def initialize(year, quarter)
    validate(year, quarter)
    @year = year
    @quarter = quarter
  end

  def validate(year, quarter)
    unless (1..4) === quarter && (2000..9999) === year
      raise ArgumentError
    end
  end

  def previous
    if (quarter == 1)
      Quarter.new(year - 1, 4)
    else
      Quarter.new(year, quarter - 1)
    end
  end

  def next
    if (quarter == 4)
      Quarter.new(year + 1, 1)
    else
      Quarter.new(year, quarter + 1)
    end
  end

  def id
    "#{year}Q#{quarter}"
  end

  def to_s
    id
  end

  def self.current
    today = Date.today
    self.from_date(today)
  end

  def self.from_date(date)
    qtr = (date.month - 1).div(3) + 1
    yr = date.year
    Quarter.new(yr.to_i,qtr.to_i)
  end

end
