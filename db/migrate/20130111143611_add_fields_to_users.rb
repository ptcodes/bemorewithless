class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country_code, :string
    add_column :users, :state_code, :string
    add_column :users, :city, :string
  end
end
