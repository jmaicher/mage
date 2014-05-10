class Device < ActiveRecord::Base
  include API::Authenticable

  devise :trackable
end
