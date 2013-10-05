class AddGiftsCountToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :gifts_count, :integer, default: 0
    Category.find_each do |category|
      category.update_attribute(:gifts_count, category.gifts.count)
      category.save
    end
  end

  def down
    remove_column :category, :gifts_count
  end
end
