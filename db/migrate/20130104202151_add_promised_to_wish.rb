class AddPromisedToWish < ActiveRecord::Migration
  def change
    add_column :wishes, :promised, :boolean
  end
end
