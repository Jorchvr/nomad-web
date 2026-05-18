class CreateTravelStories < ActiveRecord::Migration[8.1]
  def change
    create_table :travel_stories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :location
      t.string :country
      t.string :client_name
      t.date :visited_at
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
