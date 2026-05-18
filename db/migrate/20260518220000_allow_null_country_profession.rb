class AllowNullCountryProfession < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :country,    true
    change_column_null :users, :profession, true
  end
end
