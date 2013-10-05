class ChangeDescriptionTypeToTextInGifts < ActiveRecord::Migration
  def up
    change_column :gifts, :description, :text
  end

  def down
    change_column :gifts, :description, :string
  end
end
