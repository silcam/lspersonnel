class AlterRegions < ActiveRecord::Migration[5.1]
  def change

    remove_column :regions, :name, :string

    add_column  :regions, :region_code, :string
    add_column  :regions, :en, :string
    add_column  :regions, :fr, :string
    add_column  :regions, :full_en, :string
    add_column  :regions, :full_fr,  :string

  end
end
