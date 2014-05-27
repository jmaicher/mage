class User < ActiveRecord::Base
  include Roles::APIAuthenticable
  include Roles::MeetingParticipant

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end # User
