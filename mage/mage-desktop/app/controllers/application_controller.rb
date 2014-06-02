class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # -- Filter --------------------------------------------------

  def backlog_item_filter
    id = (params[:backlog_item_id].nil?) ? params[:id] : params[:backlog_item_id]
    @backlog_item = BacklogItem.find id
  end

end
