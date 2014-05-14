class User < ActiveRecord::Base
  include API::Authenticable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
