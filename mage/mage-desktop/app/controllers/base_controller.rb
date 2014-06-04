class BaseController < ActionController::Base

  # -- Filter --------------------------------------------------

  def backlog_item_filter
    id = (params[:backlog_item_id].nil?) ? params[:id] : params[:backlog_item_id]
    @backlog_item = BacklogItem.find id
  end

  def acceptance_criteria_filter
    id = (params[:acceptance_criteria_id].nil?) ? params[:id] : params[:acceptance_criteria_id]
    @criteria = @backlog_item.acceptance_criteria.find(id)
  end

  def meeting_filter
    id = (params[:meeting_id].nil?) ? params[:id] : params[:meeting_id]
    @meeting = Meeting.find id
  end

  def poker_session_filter
    id = (params[:poker_session_id].nil?) ? params[:id] : params[:poker_session_id]
    @poker_session = @meeting.poker_sessions.find id
  end

end # BaseController
