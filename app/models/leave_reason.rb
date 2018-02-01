# aka furlough, but not all of these will be furloughs
class LeaveReason < ApplicationRecord

    has_and_belongs_to_many :leaves

end
