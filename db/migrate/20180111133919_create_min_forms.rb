class CreateMinForms < ActiveRecord::Migration[5.1]
  def change
    create_table :min_forms do |t|
      t.string :top_left
      t.string :top_right
      t.string :centre
      t.string :permit_no
      t.string :decree1
      t.string :decree1_fr
      t.string :decree2
      t.string :decree2_fr
      t.string :decree3
      t.string :decree3_fr
      t.string :decree4
      t.string :decree4_fr
      t.string :decree5
      t.string :decree5_fr

      t.timestamps
    end
  end
end
