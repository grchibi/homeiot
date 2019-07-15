class CreateTphRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :tph_records do |t|
      t.datetime :dt, :null => false
      t.float :t, precision: 2
      t.float :p, precision: 2
      t.float :h, precision: 2
      t.references :iot_device, index: false

      t.timestamps
    end
    
    add_index :tph_records, [:iot_device_id, :dt], unique: true
  end
end
