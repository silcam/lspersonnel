class Department < ApplicationRecord

  has_and_belongs_to_many :languages
  belongs_to :region

  validates :name, :gender, presence: true
  validates :gender, format: { with: /\A[M|F]{1}\z/ }

  # assumes a Hash of departments to work with??
  def self.build_research_string(departments_ary)
    return nil if (departments_ary.nil? || departments_ary.size == 0)

    statement = ""
    if (departments_ary.size > 1)
      statement += "les départements "
    else
      statement += "le département "
    end

    departments_ary.each.with_index do |d,index|
      # two exceptions in all the departments
      if (d.name.downcase == "océan")
        statement += "de l'"
      elsif (d.name.downcase == "hauts-plateaux")
        statement += "des "
      # continue normally
      elsif (d.gender == "M")
        statement += "du "
      else
        statement += "de la "
      end

      statement += "#{d.name}"
      statement += "," if (departments_ary.size > 2 && index < departments_ary.size - 1)
      statement += " et " if (index < departments_ary.size - 1)
    end

    statement
  end

end
