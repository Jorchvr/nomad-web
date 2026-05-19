class AddSpecialtiesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :specialties, :text
  end
end
