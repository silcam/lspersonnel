# aka furlough, but not all of these will be furloughs
class Leave < ActiveRecord::Base

    belongs_to :person
    has_and_belongs_to_many :leave_reasons

end
