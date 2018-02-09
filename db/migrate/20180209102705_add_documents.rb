class AddDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string :minister_gender, limit: 1

      t.timestamps
    end
  end
end
