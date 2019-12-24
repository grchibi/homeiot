class CreateIpRestrictions < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_restrictions do |t|
      t.string :list_type, :null => false
      t.string :ip, :null => false
      t.string :desc
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
