class CreateAPIDevicesPins < ActiveRecord::Migration
  def change
    create_table :api_devices_pins do |t|
      t.string :pin
      t.string :uuid

      t.timestamps
    end
  end
end
