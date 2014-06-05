class User < ActiveRecord::Base
  include Roles::Activities::Actor
  include Roles::API::Authenticable
  include Roles::MeetingParticipant

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  validates_length_of :name, minimum: 5, maximum: 50
end # User
