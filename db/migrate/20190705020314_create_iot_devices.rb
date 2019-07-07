class CreateIotDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :iot_devices do |t|
      t.string :name, null: false
      t.string :desc, null: false

      t.timestamps
    end
  end
end
