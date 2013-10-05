class AddStateToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :state, :string
  end
end
