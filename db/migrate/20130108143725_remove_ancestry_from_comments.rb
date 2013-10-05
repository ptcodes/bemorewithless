class RemoveAncestryFromComments < ActiveRecord::Migration
  def up
    remove_column :comments, :ancestry
  end

  def down
  end
end
