class Involvements < ActiveRecord::Migration[5.1]
  def change

    # create new join table with attribute
    create_table :involvements do |t|
      t.belongs_to :language, index: true
      t.belongs_to :person, index: true
      t.integer :level
      t.timestamps
    end

    # remove old one-to-many reference
    remove_column :people, :language_id, :integer
  end
end
