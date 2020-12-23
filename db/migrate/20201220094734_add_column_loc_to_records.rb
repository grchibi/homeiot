class AddColumnLocToRecords < ActiveRecord::Migration[5.0]
  def up
    add_column :tph_records, :loc, :string
  end
  
  def down
    remove_column :tph_records, :loc, :string
  end
end
