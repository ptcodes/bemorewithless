class RemoveImageFromUsers < ActiveRecord::Migration
  def up
    remove_column :gifts, :image
  end

  def down
  end
end
