class User < ActiveRecord::Base
  include API::Authenticable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :meeting_participations
  has_many :meetings, through: :meeting_participations
end # User
