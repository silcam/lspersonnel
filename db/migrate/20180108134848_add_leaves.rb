class AddLeaves < ActiveRecord::Migration[5.1]
  def change

    create_table :leaves do |t|
      t.belongs_to :person, index: true
      t.date :start_date, index: true
      t.date :end_date, index: true
      t.timestamps
    end

    create_table :leave_reasons_leaves do |t|
      t.belongs_to :leave, index: true
      t.belongs_to :leave_reason, index: true
    end

    create_table :leave_reasons do |t|
      t.string :reason
      t.timestamps
    end

  end
end
