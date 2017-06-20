class AddRegionReferenceToLanguages < ActiveRecord::Migration[5.1]
  def change
    add_reference :languages, :region
  end
end
