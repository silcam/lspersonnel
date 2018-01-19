class NewAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :cabtal, :boolean, null: false, default: false

    create_table :nationalities do |t|
      t.string :nationality
    end

    create_table :titles do |t|
      t.string :titles
    end

    create_table :directors do |t|
      t.string :name
      t.string :title
      t.boolean :current, default: false, null: false
    end

  end
end
