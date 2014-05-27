class FixDeviceTypeColum < ActiveRecord::Migration
  def change
    rename_column :devices, :type, :device_type
  end
end
