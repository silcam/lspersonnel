class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :last_name
      t.string :first_name
      t.string :category
      t.string :job
      t.date :arrival
      t.date :departure
      t.string :nationality
      t.string :title
      t.string :gender, limit: 1
      t.references :language

      t.timestamps
    end
  end
end
