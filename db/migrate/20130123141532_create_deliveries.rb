class CreateDeliveries < ActiveRecord::Migration
  def up
    create_table :deliveries do |t|
      t.string :name

      t.timestamps
    end
    Delivery.create_translation_table! name: :string
  end
  def down
    drop_table :deliveries
    Delivery.drop_translation_table!
  end
end
