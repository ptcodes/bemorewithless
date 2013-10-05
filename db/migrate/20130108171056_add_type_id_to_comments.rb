class AddTypeIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :type_id, :integer
  end
end
