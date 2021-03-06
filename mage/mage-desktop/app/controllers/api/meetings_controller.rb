class API::MeetingsController < API::ApplicationController
  before_filter :authenticate_from_token!
  before_filter :authorize_device!, only: :create
  before_filter :meeting_filter, only: :show
  before_filter :complete_previous, only: :create

  def index
    meetings = Meeting.active
    coll = API::Collection.new(meetings, {
      self: api_meetings_url
    })

    render json: CollectionRepresenter.new(coll).to_json(participant: current_authenticable)
  end # index

  def show
    decorator = MeetingRepresenter.new(@meeting)
    render json: decorator.to_json(participant: current_authenticable)
  end # show

  def create
    meeting = Meeting.new initiator: current_authenticable

    # Use service layer?
    begin
      Meeting.transaction do
        meeting.save!
        current_authenticable.participate! meeting
        current_authenticable.create_activity! "meeting.start", object: meeting
      end
      
      response = MeetingRepresenter.new(meeting).to_hash
      notify_reactive('meeting.started', response)
      status = :created
    rescue => e
      Rails.logger.error e
      response = meeting.errors
      status = :unprocessable_entity
    end

    render json: response, status: status
  end # create

private

  def complete_previous
    Meeting.active.where(initiator: current_authenticable).each do |m|
      m.active = false
      m.save!
    end
  end

  def notify_reactive(type, payload)
    Reactive.instance.message_to("/activities", type, payload)
  end

end
