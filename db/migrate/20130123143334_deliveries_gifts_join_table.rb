class DeliveriesGiftsJoinTable < ActiveRecord::Migration
  def up
    create_table :deliveries_gifts, id: false do |t|
      t.integer :delivery_id
      t.integer :gift_id
    end
  end

  def down
    drop_table :deliveries_gifts
  end
end
