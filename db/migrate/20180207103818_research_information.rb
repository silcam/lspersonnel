class ResearchInformation < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :future_activities, :string, null: true
    add_column :people, :request_period, :string, null: true

    remove_column :languages, :region_id, :bigint

    create_table :departments do |t|
      t.string :name
      t.string :gender, limit: 1
      t.timestamps
      t.belongs_to :region
    end

    create_table :departments_languages do |t|
      t.belongs_to :language, index: true
      t.belongs_to :department, index: true
    end

  end
end
