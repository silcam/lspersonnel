class TablePerson < ActiveRecord::Migration[5.1]
  def change
    create_table Person
    add_column :Person, :last_name, :string
    add_column :Person, :first_name, :string
    add_column :Person, :category, :string
    add_column :Person, :job, :string
    add_column :Person, :arrival, :date
    add_column :Person, :departure, :date
    add_column :Person, :nationality, :string
    add_column :Person, :title, :string
    add_column :Person, :gender, :string['M','F']
    add_column :Person, :language, :reference
  end
end
