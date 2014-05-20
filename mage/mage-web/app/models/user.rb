class User < ActiveRecord::Base
  include API::Authenticable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :meeting_participations
  has_many :meetings, through: :meeting_participations

  def participates_in?(meeting)
    self.meetings.where(id: meeting.id).exists?
  end

  def participate!(meeting)
    self.meetings << meeting
  end
end # User
