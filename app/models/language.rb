class Language < ActiveRecord::Base
    has_many :people
    belongs_to :region
end 
