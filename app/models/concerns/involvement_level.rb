# Potentially will be better than a rails enum
# ...but maybe not -- probably will punt in the
# future and go back to a regular enum class.
class InvolvementLevel

  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  PRIMARY = InvolvementLevel.new 1, "Primary"
  SECONDARY = InvolvementLevel.new 2, "Secondary"
  TERTIARY = InvolvementLevel.new 3, "Tertiary"
  FORMER = InvolvementLevel.new 4, "Former"
  FUTURE = InvolvementLevel.new 5, "Future"

  def self.all
    [
      PRIMARY,
      SECONDARY,
      TERTIARY,
      FORMER,
      FUTURE
    ]
  end

  def self.id(id)
    InvolvementLevel.all.each do |lvl|
      if lvl.id == id.to_i
        return lvl
      end
    end

    nil
  end

  def self.get(value)
    return nil if value.nil?

    InvolvementLevel.all.each do |lvl|
      if lvl.name.downcase == value.to_s.downcase
        return lvl
      end
    end

    nil
  end

end
