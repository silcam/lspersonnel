class AssociatePeopleToTitlesNations < ActiveRecord::Migration[5.1]
  def change

    remove_column :people, :title, :string
    remove_column :people, :nationality, :string

    add_reference :people, :title, index: true
    add_reference :people, :nationality, index: true

  end
end
