class TableLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table languages
    add_column :languages, :name, :string
  end
end
