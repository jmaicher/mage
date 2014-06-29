class MeetingsController < ApplicationController
  before_action :meeting_filter
 
  def show
    @activity_stream = ActivityStream.get_for_context(@meeting)
  end

end # MeetingsController
