class CreateDevices < ActiveRecord::Migration
  def change
    create_table(:devices) do |t|
      t.string :name, :null => false
      t.integer :type, :null => false

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :devices, :name, :unique => false
  end
end
