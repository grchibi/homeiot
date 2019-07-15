class CreateIotDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :iot_devices do |t|
      t.string :uname, :null => false
      t.string :model
      t.string :desc

      t.timestamps
    end
    
    add_index :iot_devices, [:uname], unique: true
  end
end
