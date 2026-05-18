class AddLocationToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :city, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
