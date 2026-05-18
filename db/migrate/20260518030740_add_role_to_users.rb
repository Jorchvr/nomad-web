class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string, default: "nomad", null: false
    User.update_all(role: "nomad")
  end
end
