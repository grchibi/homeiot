class CreateTphHlRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :tph_hl_records do |t|
      t.date :dt, :null => false
      t.float :t, precision: 2
      t.float :p, precision: 2
      t.float :h, precision: 2
      t.boolean :is_h
      t.references :iot_device, index: false

      t.timestamps
    end
  end
end
