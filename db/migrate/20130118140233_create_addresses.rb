class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :country_code
      t.string :state_code
      t.string :city
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end
end
