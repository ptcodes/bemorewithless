class AddImageToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :image, :string
  end
end
