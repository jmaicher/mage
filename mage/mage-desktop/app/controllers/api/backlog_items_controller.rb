class API::BacklogItemsController < API::ApplicationController
  before_filter :authenticate!
  before_filter :backlog_item_filter
  before_filter :context_filter

  def show
    render json: BacklogItemRepresenter.new(@backlog_item)
  end

  def update
    if @backlog_item.update(backlog_item_params)
      current_user.create_activity! "backlog_item.update", object: @backlog_item, context: @context
      status = 200
      response = BacklogItemRepresenter.new(@backlog_item)
    else
      status = 422
      response = @backlog_item.errors
    end
  
    render json: response, status: status
  end

private

  def backlog_item_params
    params.permit(:title, :description)
  end

end # API::BacklogItemsController
