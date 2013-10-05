class AddCategoryIdToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :category_id, :integer
  end
end
