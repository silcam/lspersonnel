class AddResearchPermit < ActiveRecord::Migration[5.1]
  def change
      add_column :periodic_documents, :identifier, :string
      add_reference :periodic_documents, :language
  end
end
