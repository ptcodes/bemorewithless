class AddGiftIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :gift_id, :integer
  end
end
