class API::Sprints::SprintBacklogItemsController < API::ApplicationController
  before_filter :authenticate!
  before_filter :sprint_filter

  def create
    backlog_item = BacklogItem.find(params[:backlog_item_id])
    backlog_item.backlog = @sprint.backlog

    if backlog_item.save
      response = SprintBacklogItemRepresenter.new(backlog_item)
      status = 201
    else
      response = backlog_item.errors
      status = 422
    end

    render json: response, status: status

  end

private

  def sprint_backlog_item_params
    params.permit(:backlog_item_id)
  end

end # ::BacklogItemAssignmentsController
