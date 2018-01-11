class CreatePeriodicDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :periodic_documents do |t|
      t.string :type
      t.string :quarter
      t.date :issue_date
      t.date :expiry_date
      t.date :submission_date
      t.references :person, index: true
      t.timestamps
    end
  end
end
