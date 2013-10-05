class RemoveFieldsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :country_code
    remove_column :users, :state_code
    remove_column :users, :city
  end

  def down
    add_column :users, :city, :string
    add_column :users, :state_code, :string
    add_column :users, :country_code, :string
  end
end
