class AddGiftIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :gift_id, :integer
  end
end
