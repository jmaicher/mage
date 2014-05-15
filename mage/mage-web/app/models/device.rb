class Device < ActiveRecord::Base
  include API::Authenticable

  devise :trackable

  TYPE = { table: 1, board: 2 }

  def device_type=(t)
    write_attribute(:device_type, TYPE[t])
  end

  def device_type
    TYPE.key(read_attribute(:device_type))
  end

  # -- Validations --------------------------------------

  validates_presence_of :name

end
