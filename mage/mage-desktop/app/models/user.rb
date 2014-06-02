class User < ActiveRecord::Base
  include Roles::Activities::Actor
  include Roles::API::Authenticable
  include Roles::MeetingParticipant

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end # User
