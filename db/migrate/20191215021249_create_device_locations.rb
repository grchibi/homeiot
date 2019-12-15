class CreateDeviceLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :device_locations do |t|
      t.string :loc_ident, :null => false
      t.string :desc
      t.references :iot_device
      t.timestamps
    end
  end
end
